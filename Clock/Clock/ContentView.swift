import DisplayLink
import SwiftUI

struct ContentView: View {
    @State private var date = Date()

    var body: some View {
        ClockView(accuracy: .threeHands, date: date)
            .padding()
            .onFrame { _ in
                self.date = Date()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
