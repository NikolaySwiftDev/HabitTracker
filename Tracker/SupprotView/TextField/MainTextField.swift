

import SwiftUI

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String

    func makeUIView(context: Context) -> UITextField {
        let textField = EmojiOnlyTextField()
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.font = .systemFont(ofSize: 22)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}


final class EmojiOnlyTextField: UITextField {

    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return super.textInputMode
    }
}

final class Coordinator: NSObject, UITextFieldDelegate {
    let parent: EmojiTextField
    private var didClearPlaceholder = false

    init(_ parent: EmojiTextField) {
        self.parent = parent
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard !didClearPlaceholder else { return }

        textField.text = ""
        parent.text = ""
        didClearPlaceholder = true
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        let currentText = textField.text ?? ""
        let nsText = currentText as NSString
        let updatedText = nsText.replacingCharacters(in: range, with: string)

        if updatedText.isEmpty {
            textField.text = ""
            parent.text = ""
            return false
        }

        if let last = updatedText.last, last.isEmoji {
            textField.text = String(last)
            parent.text = String(last)
        }

        return false
    }
}


extension Character {
    var isEmoji: Bool {
        unicodeScalars.first?.properties.isEmojiPresentation == true
    }
}
