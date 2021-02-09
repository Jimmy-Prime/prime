import Foundation

class HTTPLoader {
    var nextLoader: HTTPLoader? {
        willSet {
            guard nextLoader == nil else {
                fatalError("nextLoader should only be set once")
            }
        }
    }

    func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        if let nextLoader = nextLoader {
            nextLoader.load(request: request, completion: completion)
        } else {
            let error = HTTPError(code: .cannotConnect, request: request)
            completion(.failure(error))
        }
    }

    // MARK: Reset
    final func reset(on queue: DispatchQueue, completion: @escaping () -> Void) {
        let group = DispatchGroup()

        reset(with: group)

        group.notify(queue: queue, execute: completion)
    }

    func reset(with group: DispatchGroup) {
        nextLoader?.reset(with: group)
    }
}

class URLSessionLoader: HTTPLoader {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        guard let url = request.url else {
            completion(.failure(HTTPError(code: .cannotBuildURL, request: request)))
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod.rawValue

        for (header, value) in request.headers {
            urlRequest.addValue(value, forHTTPHeaderField: header)
        }

        if !request.body.isEmpty {
            for (header, value) in request.body.additionalHeaders {
                urlRequest.addValue(value, forHTTPHeaderField: header)
            }

            do {
                urlRequest.httpBody = try request.body.encode()
            } catch {
                completion(.failure(HTTPError(code: .cannotEncodeDataBody, request: request, underlyingError: error)))
                return
            }
        }

        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            completion(HTTPResult(request: request, data: data, response: response, error: error))
        }

        dataTask.resume()
    }
}

// Mark: - Utilities

class PrintLoader: HTTPLoader {
    override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        print("begin loading \(request)")
        super.load(request: request) { (result) in
            print("finish loading \(request)")
            completion(result)
        }
    }
}

class ModifyRequest: HTTPLoader {
    private let modifier: (HTTPRequest) -> HTTPRequest

    init(modifier: @escaping (HTTPRequest) -> HTTPRequest) {
        self.modifier = modifier
    }

    override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        let modified = modifier(request)
        super.load(request: modified, completion: completion)
    }
}

// TODO: Apply Environment:
    // apply host, path, header, ...
    // init(env: ServerEnvironment)
    // apply env in ModifyRequest.modifier

class ResetGuard: HTTPLoader {
    private var isResetting: Bool = false

    override func load(request: HTTPRequest, completion: @escaping (HTTPResult) -> Void) {
        // TODO: make this thread safe
        if isResetting {
            completion(.failure(HTTPError(code: .isResetting, request: request)))
        } else {
            super.load(request: request, completion: completion)
        }
    }

    override func reset(with group: DispatchGroup) {
        // TODO: make this thread safe

        if isResetting {
            return
        }

        guard let nextLoader = nextLoader else { return }

        group.enter()
        isResetting = true
        nextLoader.reset(on: .main) { // TODO: reset on main queue?
            self.isResetting = false
            group.leave()
        }
    }
}

// let chain = resetGuard --> applyEnvironment --> ... --> urlSessionLoader
