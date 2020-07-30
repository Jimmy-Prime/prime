import Foundation

protocol Request: URLRequestBuildable {
    var host: URL { get }
    var path: String { get }
    var queryItems: [String: String] { get }
    // TODO: json body
}

protocol DataRequest {
    associatedtype Response: Codable

    static var decoder: JSONDecoder { get }
}

extension DataRequest {
    static var decoder: JSONDecoder {
        JSONDecoder()
    }
}

// MARK: - Build Request

protocol URLRequestBuildable {
    var url: URL { get }
    var urlRequest: URLRequest { get }
}

extension Request {
    var url: URL {
        guard var components = URLComponents(url: host, resolvingAgainstBaseURL: false) else {
            fatalError("Cannot build URLComponents from \(host)")
        }

        components.path = (components.path as NSString).appendingPathComponent(path)

        if !queryItems.isEmpty {
            components.queryItems = queryItems
                .map { .init(name: $0.key, value: $0.value) }
        }

        guard let url = components.url else {
            fatalError("Cannot build url from URLComponents. Please check path: \(path), and parameters: \(queryItems)")
        }

        return url
    }

    var urlRequest: URLRequest {
        // TODO: json body

        URLRequest(url: url)
    }
}

struct GeneralError: Error {}

extension URLSession {
    func send<T: Request & DataRequest>(_ request: T, completion: @escaping (Result<T.Response, Error>) -> Void) {
        let dataTask = self.dataTask(with: request.urlRequest) { (data, response, error) in
            if let error = error {
                // TODO: os_log error
                completion(.failure(error))
                return
            }

            guard let data = data, let response = response else {
                // TODO: os_log error
                completion(.failure(GeneralError()))
                return
            }

            #if DEBUG
            print(String(decoding: data, as: UTF8.self))
            #endif

            do {
                let decoded = try T.decoder.decode(T.Response.self, from: data)
                completion(.success(decoded))
            } catch {
                #if DEBUG
                print(error)
                #endif
                completion(.failure(error))
            }
        }

        dataTask.resume()
    }
}
