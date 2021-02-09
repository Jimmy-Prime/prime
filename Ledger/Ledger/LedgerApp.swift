import SwiftUI

@main
struct LedgerApp: App {
    @State var showPopup: Bool = false
    @State var text: String = ""

    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
//                    CalculatorTextField(text: $text)
//                        .frame(width: 200, height: 24)

                    Button("OAO") {
                        showPopup.toggle()
                    }
                }
                    .navigationBarTitle(Text("Ledger"), displayMode: .inline)
            }
                .navigationViewStyle(StackNavigationViewStyle())
                .sheet(isPresented: $showPopup) {
                    NavigationView {
                        AddTransactionView()
                    }
                }
        }
    }
}

// extension View {
//    func card() -> some View {
//        self
//            .background(Color(.systemGray))
//            .cornerRadius(16)
//            .shadow(color: Color(UIColor(named: "Shadow")!), radius: 30)
//    }
//
//    func borderCard() -> some View {
//        self
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(lineWidth: 2)
//            )
//    }
//
//    func gradientCard() -> some View {
//        self
//            .background(
//                LinearGradient(
//                    gradient: Gradient(
//                        colors: [
//                            // 0x6D678E, 0xF6B5CC
//                            // 0xD74177, 0xFFE98A
//                            // 0x2C90C4, 0x31CCB0
//                            // 0xD1C6F3, 0xE9BCAC
//                            // 0xee9ca7, 0xffdde1
//                            // 0xC6FFDD, 0xFBD786, 0xf7797d
//                            // 0x0F2027, 0x203A43, 0xf7797d
//                            Color(UIColor(hexRGB: 0x8E0E00)),
//                            Color(UIColor(hexRGB: 0x1F1C18))
//                        ]
//                    ),
//                    startPoint: .topLeading,
//                    endPoint: .bottomTrailing
//                )
//            )
//            .cornerRadius(16)
//            .shadow(color: Color(UIColor(named: "Shadow")!), radius: 30)
//    }
// }
