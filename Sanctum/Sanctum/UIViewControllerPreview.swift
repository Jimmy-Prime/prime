import SwiftUI

struct UIViewControllerPreview<VC: UIViewController>: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> VC {
        VC()
    }

    func updateUIViewController(_ uiViewController: VC, context: Context) {
        // leave empty
    }

    typealias UIViewControllerType = VC
}

struct UIViewControllerPreview_Previews: PreviewProvider {
    static var targetView: some View {
        UIViewControllerPreview<LoginViewController>()
    }

    static var previews: some View {
        Group {
            targetView
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .previewDisplayName("iPhone light")

            targetView
                .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro Max"))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("iPhone dark")

            targetView
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
                .previewDisplayName("iPad light")

            targetView
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
                .environment(\.colorScheme, .dark)
                .previewDisplayName("iPad dark")
        }
    }
}
