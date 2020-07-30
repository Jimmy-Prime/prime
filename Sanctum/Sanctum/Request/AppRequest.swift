import Foundation

protocol AppRequest: SynoRequest {}

extension AppRequest {
    var host: URL {
        URL(string: "https://chat.synology.com")!
    }

    var path: String {
        "/webapi/entry.cgi"
    }
}

struct EncryptRequest: AppRequest, DataRequest {
    struct Response: Codable {
        let cipherKey: String
        let cipherToken: String
        let publicKey: String
        let serverTime: Int64

        private enum CodingKeys: String, CodingKey {
            case cipherKey = "cipherkey"
            case cipherToken = "ciphertoken"
            case publicKey = "public_key"
            case serverTime = "server_time"
        }
    }

    let path: String = "/webapi/encryption.cgi"
    let api: String = "SYNO.API.Encryption"
    let method: String = "getinfo"
    let version: Int = 1
    let additionalQueryItems: [String: String] = ["query": "all"]
}

struct AuthRequest: AppRequest, DataRequest {
    struct Response: Codable {
        let sid: String
    }

    let path: String = "/webapi/auth.cgi"
    let api: String = "SYNO.API.Auth"
    let method: String = "login"
    let version: Int = 6
    let additionalQueryItems: [String: String]

    init(encrypt: EncryptRequest.Response, account: String, password: String) {
        var result: [String: String] = [
            "client_time": "\(Date().timeIntervalSince1970)",
            "session": "Chat",
            "format": "cookie"
        ]

        let encryption = SynoCGIEncryption(
            timeBias: Int(encrypt.serverTime) - Int(Date().timeIntervalSince1970),
            cipherText: encrypt.cipherKey,
            cipherToken: encrypt.cipherToken,
            publicKey: encrypt.publicKey
        )

        if let encryption = encryption {
            let encrypted = encryption.encrypt(from: ["account": account, "passwd": password])
            for (key, value) in encrypted {
                result[key] = value
            }
        } else {
            result["account"] = account
            result["passwd"] = password
        }

        additionalQueryItems = result
    }
}
