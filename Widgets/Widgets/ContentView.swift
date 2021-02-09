import DisplayLink
import SwiftUI
import WidgetKit

struct ContentView: View {
    @State var blankActive: Bool = false
    @State var clockActive: Bool = false
    @State var noteActive: Bool = false
    @State var gifActive: Bool = false

    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Text(""), isActive: $blankActive) {
                    Text("Blank")
                }

                NavigationLink(destination: ClockItemView(), isActive: $clockActive) {
                    Text("Clock")
                }

                NavigationLink(destination: NoteItemView(), isActive: $noteActive) {
                    Text("Note")
                }

                NavigationLink(destination: PartyBlob().padding(), isActive: $gifActive) {
                    Text("PartyBlob")
                }
            }
                .navigationBarTitle(Text("Widgets"), displayMode: .inline)
                .onOpenURL(perform: { (url) in
                    self.blankActive = url == URL(string: "widget:///blank")!
                    self.clockActive = url == URL(string: "widget:///clock")!
                    self.noteActive = url == URL(string: "widget:///note")!
                    self.gifActive = url == URL(string: "widget:///gif")!
                })
        }
    }
}

struct ClockItemView: View {
    @State private var date = Date()

    var body: some View {
        ClockView(accuracy: .threeHands, date: date)
            .padding()
            .onFrame { _ in
                self.date = Date()
            }
    }
}

struct NoteItemView: View {
    @State var text = Defaults.note

    var body: some View {
        VStack {
            TextEditor(text: $text)
            Button("Update") {
                Defaults.note = text
                WidgetCenter.shared.reloadTimelines(ofKind: "Note")
            }
                .padding()
                .background(Color.primary)
                .cornerRadius(.greatestFiniteMagnitude)
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ClockItemView()
            NoteItemView()
        }
    }
}
