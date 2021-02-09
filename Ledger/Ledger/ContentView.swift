import SwiftUI

struct ContentView: View {
    @State var text: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                TextField("新增種類", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: add) {
                    Image(systemName: "plus.circle.fill")
                }
            }

            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("常用")

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(filteredTags(by: text), id: \.self) { tag in
                                    tagView(tag)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("所有")

                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(filteredTags(by: text), id: \.self) { tag in
                                tagView(tag)
                            }
                        }
                    }
                }
            }
        }
            .padding()
            .navigationBarTitle(Text("種類"), displayMode: .inline)
    }

    func tagView(_ tag: String) -> some View {
        Text(tag)
            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
            .background(Color(.systemFill))
            .cornerRadius(8)
    }

    private func add() {
        // TODO
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
