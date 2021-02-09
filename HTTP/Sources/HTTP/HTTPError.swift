struct HTTPError: Error {
    let code: Code
    let request: HTTPRequest
    let response: HTTPResponse?
    let underlyingError: Error?

    init(code: HTTPError.Code, request: HTTPRequest, response: HTTPResponse? = nil, underlyingError: Error? = nil) {
        self.code = code
        self.request = request
        self.response = response
        self.underlyingError = underlyingError
    }

    // TODO: add more cases
    enum Code {
        // HTTPLoader chain
        case cannotConnect
        case isResetting

        // before sending request
        case cannotBuildURL
        case cannotEncodeDataBody

        // after URLSession data task complete
        case URLError
        case unknown
        case notHTTPResponse
    }
}
