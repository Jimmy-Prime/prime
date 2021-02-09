struct HTTPMethod: RawRepresentable {
    let rawValue: String
}

extension HTTPMethod {
    static var get: HTTPMethod { HTTPMethod(rawValue: "GET") }
    static var post: HTTPMethod { HTTPMethod(rawValue: "POST") }
}
