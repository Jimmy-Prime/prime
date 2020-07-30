import Foundation

struct SynoCGIEncryption {
    private let timeBias: Int
    private let cipherText: String
    private let cipherToken: String
    private let publicKey: SecKey

    init?(timeBias: Int, cipherText: String, cipherToken: String, publicKey: String) {
        self.timeBias = timeBias
        self.cipherText = cipherText
        self.cipherToken = cipherToken

        let attributes = [
            kSecAttrKeyType: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass: kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits: 4096
        ] as CFDictionary

        guard let publicKeyData = Data(base64Encoded: publicKey),
            let key = SecKeyCreateWithData(publicKeyData as CFData, attributes, nil) else {
            return nil
        }

        self.publicKey = key
    }

    func encrypt(from paramString: String) -> String {
        if let encrypted = encrypt(plainString: paramString) {
            return "\(cipherText)=\(encrypted)"
        } else {
            return paramString
        }
    }

    func encrypt(from paramDictionary: [String: String]) -> [String: String] {
        let dictionaryString = paramDictionary
            .compactMap { key, value in
                guard let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
                guard let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }

                return "\(encodedKey)=\(encodedValue)"
            }
            .joined(separator: "&")

        if let encrypted = encrypt(plainString: dictionaryString) {
            return [cipherText: encrypted]
        } else {
            return paramDictionary
        }
    }

    private func encrypt(plainString: String) -> String? {
        let timeToken = Int(Date().timeIntervalSince1970) + timeBias
        let plainString = "\(cipherToken)=\(timeToken)&\(plainString)"
        return encrypt(plainData: Data(plainString.utf8))?.base64EncodedString()
    }

    private func encrypt(plainData: Data) -> Data? {
        let maxSize = SecKeyGetBlockSize(publicKey)
        if maxSize <= 0 || maxSize - plainData.count < 12 {
            return nil
        }

        var cipherSize: Int = maxSize
        var cipherData: [UInt8] = Array(repeating: 0, count: cipherSize)
        guard SecKeyEncrypt(publicKey, .PKCS1, Array(plainData), plainData.count, &cipherData, &cipherSize) == errSecSuccess else { return nil }

        return Data(bytes: cipherData, count: cipherSize)
    }
}
