import Foundation

struct HTTPStatus {
    let code: Int
}

struct HTTPResponse {
    let request: HTTPRequest
    private let response: HTTPURLResponse
    let body: Data?

    init(request: HTTPRequest, response: HTTPURLResponse, body: Data?) {
        self.request = request
        self.response = response
        self.body = body
    }

    var status: HTTPStatus {
        HTTPStatus(code: response.statusCode)
    }

    var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    var headers: [AnyHashable: Any] {
        response.allHeaderFields
    }
}
