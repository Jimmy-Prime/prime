import Foundation

typealias HTTPResult = Result<HTTPResponse, HTTPError>

extension HTTPResult {
    init(request: HTTPRequest, data: Data?, response: URLResponse?, error: Error?) {
        var httpResponse: HTTPResponse?
        if let response = response as? HTTPURLResponse {
            httpResponse = HTTPResponse(request: request, response: response, body: data)
        }

        if let urlError = error as? URLError {
            self = .failure(HTTPError(code: .URLError, request: request, response: httpResponse, underlyingError: urlError))
        } else if let error = error {
            self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: error))
        } else if let httpResponse = httpResponse {
            self = .success(httpResponse)
        } else {
            self = .failure(HTTPError(code: .notHTTPResponse, request: request, underlyingError: error))
        }
    }
}

extension HTTPResult {
    var request: HTTPRequest {
        switch self {
        case .success(let response):
            return response.request
        case .failure(let error):
            return error.request
        }
    }

    var response: HTTPResponse? {
        switch self {
        case .success(let response):
            return response
        case .failure(let error):
            return error.response
        }
    }
}
