import Foundation

protocol HTTPRequestOption {
    associatedtype Value

    static var defaultValue: Value { get }
}

struct HTTPRequest {
    // MARK: Basics
    private var urlComponents = URLComponents()
    var httpMethod: HTTPMethod = .get
    var headers: [String: String] = [:] // TODO: should be case insensitive
    var body: HTTPBody = EmptyBody()

    init() {
        urlComponents.scheme = "https"
    }

    var url: URL? {
        urlComponents.url
    }

    // MARK: Options
    private var options: [ObjectIdentifier: Any] = [:]

    subscript<Option: HTTPRequestOption>(option type: Option.Type) -> Option.Value {
        get {
            if let value = options[ObjectIdentifier(type)] as? Option.Value {
                return value
            } else {
                return type.defaultValue
            }
        }
        set {
            options[ObjectIdentifier(type)] = newValue
        }
    }
}
