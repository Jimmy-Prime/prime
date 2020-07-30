import SwiftUI

struct LoginView: View {
    @State var account: String = ""
    @State var password: String = ""

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                TextField("帳號", text: $account)
                    .textContentType(.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("密碼", text: $password)
                    .textContentType(.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            // how to match height with VStack
            Button(
                action: {},
                label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.largeTitle)
                }
            )
        }
            .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
