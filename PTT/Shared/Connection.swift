import Foundation
import SocketIO

class Connection {
    static let shared = Connection()

    var manager: SocketManager!

    func makeConnection() {
//        let request = URLRequest(url: URL(string: "https://chat.synology.com")!)
//        let socket = WebSocket(request: request)
//        socket.delegate = self
//        socket.connect()

        print("make connection")

        manager = SocketManager(socketURL: URL(string: "https://term.ptt.cc")!)

        manager.defaultSocket.connect()

        manager.defaultSocket.onAny { (event) in
            print(event.event)

            if let items = event.items {
                for item in items {
                    print(type(of: item))
                    print(item)
                    print("---")
                }
            } else {
                print("nil items")
            }
        }

    }
}
