import Foundation

protocol HTTPBody {
    var isEmpty: Bool { get }
    var additionalHeaders: [String: String] { get }
    func encode() throws -> Data
}

struct EmptyBody: HTTPBody {
    let isEmpty: Bool = true
    let additionalHeaders: [String: String] = [:]
    func encode() throws -> Data {
        Data()
    }
}

struct DataBody: HTTPBody {
    var isEmpty: Bool { data.isEmpty }
    let additionalHeaders: [String: String]
    func encode() throws -> Data {
        data
    }

    let data: Data

    init(_ data: Data, additionalHeaders: [String: String] = [:]) {
        self.data = data
        self.additionalHeaders = additionalHeaders
    }
}

struct JSONBody: HTTPBody {
    let isEmpty: Bool = false
    let additionalHeaders: [String: String] = [
        "Content-Type": "application/json; charset=utf-8"
    ]
    func encode() throws -> Data {
        try encoder()
    }

    private let encoder: () throws -> Data

    init<T: Encodable>(_ value: T, encoder: JSONEncoder = JSONEncoder()) {
        self.encoder = { try encoder.encode(value) }
    }
}

struct FormBody: HTTPBody {
    let isEmpty: Bool = false
    let additionalHeaders: [String: String] = [
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    ]
    func encode() throws -> Data {
        let string = items
            .map(urlEncode)
            .joined(separator: "&")
        return Data(string.utf8)
    }

    private let items: [URLQueryItem]

    init(_ values: [URLQueryItem]) {
        self.items = values
    }

    init(_ values: [String: String]) {
        self.items = values.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
    }

    private func urlEncode(_ item: URLQueryItem) -> String {
        let name = urlEncode(item.name)
        let value = urlEncode(item.value ?? "")
        return "\(name)=\(value)"
    }

    private func urlEncode(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }
}

// TODO: InputStream Data Body?
