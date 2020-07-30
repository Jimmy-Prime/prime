import Combine
import Foundation
//import os.log

protocol SynoRequest: Request {
    var api: String { get }
    var method: String { get }
    var version: Int { get }
    var additionalQueryItems: [String: String] { get }
}

extension SynoRequest {
    var queryItems: [String : String] {
        var items = additionalQueryItems
        items["api"] = api
        items["method"] = method
        items["version"] = String(version)
        return items
    }
}

//struct SynoCompoundRequest {} // TODO

// MARK: - Send Request

struct SynoResponse<T: Codable>: Codable {
    let data: T
}

struct SynoError: Codable {
    struct ErrorMessage: Codable {
        let code: Int
    }

    let error: ErrorMessage
}

extension SynoError: CustomStringConvertible {
    var description: String {
        "Code: \(error.code)"
    }
}

enum SynoRequestError: Error {
    case syno(SynoError)
    case invalid(Data, URLResponse)
    case error(Error)
    case unknown
}

extension SynoRequestError: CustomStringConvertible {
    var description: String {
        switch self {
        case .syno(let error):
            return error.description
        case .invalid(let data, let response):
            return "invalid response (data: \(data), response: \(response))"
        case .error(let error):
            return "system error \(error)"
        case .unknown:
            return "unknown error"
        }
    }
}

extension JSONDecoder {
    static var syno: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        return decoder
    }
}

extension URLSession {
    func send<T: SynoRequest & DataRequest>(_ request: T, decoder: JSONDecoder = .syno) -> AnyPublisher<T.Response, SynoRequestError> {
        dataTaskPublisher(for: request.urlRequest)
            .tryMap { (data: Data, response: URLResponse) in
                if let decoded = try? decoder.decode(SynoResponse<T.Response>.self, from: data) {
                    return decoded.data
                } else if let error = try? decoder.decode(SynoError.self, from: data) {
//                    osLog(log: .request, level: .info, "\(request.url) failed with SynoError \(error)")
                    throw SynoRequestError.syno(error)
                } else {
                    throw SynoRequestError.invalid(data, response)
                }
            }
            .mapError { error in
                switch error {
                case let synoRequestError as SynoRequestError:
                    return synoRequestError
                default:
                    return .error(error)
                }
            }
            .eraseToAnyPublisher()
    }

    func send<T: SynoRequest & DataRequest>(
        _ request: T,
        decoder: JSONDecoder = .syno,
        completion: @escaping (Result<T.Response, SynoRequestError>) -> Void
    ) {
        let dataTask = self.dataTask(with: request.urlRequest) { (data, response, error) in
            if let error = error {
//                osLog(log: .request, level: .info, "\(request.url) failed with URLError \(error.localizedDescription)")
                completion(.failure(.error(error)))
                return
            }

            guard let data = data, let response = response else {
                completion(.failure(.unknown))
                return
            }

            if let decoded = try? decoder.decode(SynoResponse<T.Response>.self, from: data) {
                completion(.success(decoded.data))
            } else if let error = try? decoder.decode(SynoError.self, from: data) {
//                osLog(log: .request, level: .info, "\(request.url) failed with SynoError \(error)")
                completion(.failure(.syno(error)))
            } else {
                completion(.failure(.invalid(data, response)))
            }
        }
        dataTask.resume()
    }
}
