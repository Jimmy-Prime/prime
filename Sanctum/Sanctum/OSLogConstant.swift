import Foundation
import os

extension OSLog {
    static var debug: OSLog {
        OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "debug")
    }

    static var request: OSLog {
        OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "request")
    }
}
