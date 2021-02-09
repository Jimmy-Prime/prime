import SwiftUI

class CalculatorInputView: UIInputView {
    struct Actions {
        var inputChar: (String) -> Void
    }

    var actions: Actions?

    func initailize() {
        let size: CGFloat = 44
        let spacing: CGFloat = 4

        for x in 0..<3 {
            for y in 0..<3 {
                let rect = CGRect(
                    x: (size + spacing) * CGFloat(x),
                    y: (size + spacing) * CGFloat(y),
                    width: size,
                    height: size
                )

                let action = UIAction { [weak self] _ in
                    print(x * 3 + y)
                    UIDevice.current.playInputClick()
                    self?.actions?.inputChar("\(x * 3 + y)")
                }

                let button = UIButton(type: .system, primaryAction: action)
                button.frame = rect
                button.setTitle("\(x * 3 + y)", for: .normal)
                button.backgroundColor = .systemFill
                addSubview(button)
            }
        }
    }
}

struct CalculatorTextField: UIViewRepresentable {
    typealias UIViewType = UITextField

    @Binding var text: String

    func makeUIView(context: Context) -> UIViewType {
        let textField = UITextField()
        textField.borderStyle = .roundedRect

        let inputView = CalculatorInputView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200), inputViewStyle: .keyboard)
        inputView.initailize()
        textField.inputView = inputView

        inputView.actions = .init(
            inputChar: { char in
                text.append(char)
            }
        )

        return textField
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.text = text
    }
}
