import Foundation

protocol CredentialStorage {
    func load() -> Credential?
    func save(credential: Credential)
    func delete(credential: Credential)
}

struct KeychainCredentialStorage: CredentialStorage {
    func load() -> Credential? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "chat.synology.com",
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]

        var keyChainItem: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &keyChainItem)

        guard status != errSecItemNotFound else { return nil } // no password
        guard status == errSecSuccess else { return nil } // unhandled error

        guard let item = keyChainItem as? [String: Any],
              let account = item[kSecAttrAccount as String] as? String,
              let passwordData = item[kSecValueData as String] as? Data else { return nil }
        let password = String(decoding: passwordData, as: UTF8.self)

        return Credential(account: account, password: password)
    }

    func save(credential: Credential) {
        do {
            try write(credential: credential)
        } catch {
            update(credential: credential)
        }
    }

    func delete(credential: Credential) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "chat.synology.com"
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { return }
    }

    private func write(credential: Credential) throws {
        struct Error: Swift.Error {}

        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "chat.synology.com",
            kSecAttrAccount as String: credential.account,
            kSecValueData as String: Data(credential.password.utf8)
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw Error() }
    }

    private func update(credential: Credential) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrServer as String: "chat.synology.com"
        ]

        let attributes: [String: Any] = [
            kSecAttrAccount as String: credential.account,
            kSecValueData as String: Data(credential.password.utf8)
        ]

        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { return } // no password
        guard status == errSecSuccess else { return } // unhandled error
    }
}
