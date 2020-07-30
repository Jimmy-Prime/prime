struct TimeoutCheckRequest: AppRequest {
    let api: String = "SYNO.Core.Desktop.Timeout"
    let method: String = "check"
    let version: Int = 1
    let additionalQueryItems: [String: String] = [:]
}

extension TimeoutCheckRequest: DataRequest {
    struct Response: Codable {
        let success: Bool
    }
}
