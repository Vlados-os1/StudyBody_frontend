//
// CustomTextField.swift
// StudyBody
//

import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String?
    let isSecure: Bool
    let keyboardType: UIKeyboardType
    let autocapitalization: TextInputAutocapitalization
    let validationMessage: String?
    
    init(
        title: String,
        text: Binding<String>,
        placeholder: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences,
        validationMessage: String? = nil
    ) {
        self.title = title
        self._text = text
        self.placeholder = placeholder ?? title
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.validationMessage = validationMessage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            
            Group {
                if isSecure {
                    SecureField(placeholder ?? "", text: $text)
                } else {
                    TextField(placeholder ?? "", text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(validationMessage != nil ? Color.red : Color.clear, lineWidth: 1)
            )
            
            if let validationMessage = validationMessage {
                Text(validationMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
    }
}
