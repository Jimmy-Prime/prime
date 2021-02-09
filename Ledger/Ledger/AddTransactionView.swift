import SwiftUI

struct AddTransactionView: View {
    @State var amount: String = "22000"
    @State var type: String = "-"
    @State var date: Date = Date()
    @State var kind: String = "🍱 吃"
    @State var name: String = "水餃"
    @State var description: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    TextField("金額", text: $amount)
                        .font(.largeTitle)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.asciiCapableNumberPad)

                        Picker("", selection: $type) {
                            Text("支出")
                                .tag("-")
                            Text("收入")
                                .tag("+")
                        }
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 80)
                }

                DatePicker("", selection: $date)
                    .datePickerStyle(CompactDatePickerStyle())

                Divider()

                kindSection

                HStack {
                    Text("名稱")

                    TextField("名稱", text: $name)
                        .multilineTextAlignment(.trailing)
                }

                HStack {
                    Text("備註")

                    TextField("選填", text: $description)
                        .multilineTextAlignment(.trailing)
                }
            }
                .padding()
                .navigationBarTitle(Text("記帳"), displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: {}) {
                        Text("取消")
                    },
                    trailing: Button(action: {}) {
                        Text("完成")
                    }
                )
        }
    }

    var kindSection: some View {
        VStack {
            HStack {
                Text("種類")

                Spacer()

                NavigationLink(destination: ContentView()) {
                    tagView(kind)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(tags, id: \.self) { tag in
                        tagView(tag)
                    }
                }
            }
        }
    }

    func tagView(_ tag: String) -> some View {
        Text(tag)
            .padding(EdgeInsets(top: 6, leading: 8, bottom: 6, trailing: 8))
            .background(Color(.systemFill))
            .cornerRadius(8)
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionView()
            .preferredColorScheme(.dark)
    }
}

//
// struct AddTransactionView: View {
//    @Binding var showAddTransactionView: Bool
//
//    @State var amount: String = ""
//    @State var sign: Int = -1
//    @State var date: Date = Date()
//    @State var type: String = ""
//    @State var tags: [String] = [] // TODO: formatting
//
//    @State var isTypeTextFieldFirstResponder: Bool = false
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack {
//                    HStack {
//                        Picker(selection: $sign, label: Text("Picker")) {
//                            Text("支出").tag(-1)
//                            Text("收入").tag(1)
//                        }
//                            .pickerStyle(SegmentedPickerStyle())
//                            .frame(width: 80)
//
//                        TextField("金額", text: $amount)
//                            .keyboardType(.asciiCapableNumberPad)
//                    }
//
//                    Divider()
//
//                    DatePicker("日期", selection: $date, displayedComponents: .date)
//
//                    Divider()
//
//                    VStack(alignment: .leading) {
//                        TextField("種類", text: $type, onEditingChanged: { isFirstResponder in
//                            withAnimation {
//                                isTypeTextFieldFirstResponder = isFirstResponder
//                            }
//                        })
//
//                        AutoCompletionView(keyword: type, showAll: isTypeTextFieldFirstResponder)
//                    }
//
//                    Divider()
//
//                    TextField("標籤", text: Binding.constant("OAO"))
//                }
//                    .padding()
//            }
//                .navigationBarTitle(Text(""), displayMode: .inline)
//                .navigationBarItems(
//                    leading: Button(
//                        action: {
//                            showAddTransactionView.toggle()
//                        },
//                        label: {
//                            Image(systemName: "xmark")
//                                .imageScale(.large)
//                        }
//                    ),
//                    trailing: Button(
//                        action: {
//                            print("amount", Int(amount)! * sign)
//                            print("date", date)
//                            print("type", type)
//                            print("tags", tags)
//
//                            showAddTransactionView.toggle()
//                        },
//                        label: {
//                            Image(systemName: "checkmark")
//                                .imageScale(.large)
//                        }
//                    )
//                )
//        }
//    }
// }
//
// struct AddTransactionView_Previews: PreviewProvider {
//    @State static var showAddTransactionView: Bool = true
//    static var previews: some View {
//        AddTransactionView(showAddTransactionView: $showAddTransactionView)
//            .preferredColorScheme(.dark)
//    }
// }
//
// struct AutoCompletionView: View {
//    let keyword: String
//    let showAll: Bool
//
//    let recentOptions: [String] = ["a", "aa", "b", "bb"]
//    let allOptions: [String] = ["a", "aa", "aaa", "b", "bb", "bbb"]
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            VStack(alignment: .leading) {
//                Text("最近使用 / 經常使用")
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(filteredRecentOptions, id: \.self) { option in
//                            Text(option)
//                                .padding()
//                                .card()
//                        }
//                    }
//                }
//            }
//
//            if showAll {
//                VStack(alignment: .leading) {
//                    Text("所有種類")
//                    ScrollView {
//                        VStack(alignment: .leading) {
//                            ForEach(filteredAllOptions, id: \.self) { option in
//                                Text(option)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    var filteredRecentOptions: [String] {
//        if keyword.isEmpty {
//            return recentOptions
//        } else {
//            return recentOptions.filter { $0.contains(keyword) }
//        }
//    }
//
//    var filteredAllOptions: [String] {
//        if keyword.isEmpty {
//            return allOptions
//        } else {
//            return allOptions.filter { $0.contains(keyword) }
//        }
//    }
// }
