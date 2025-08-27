//
//  CustomTextField.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let icon: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var contentType: UITextContentType? = nil
    
    @State private var isPasswordVisible = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: Constants.UI.smallSpacing) {
            // Icon
            Image(systemName: icon)
                .foregroundColor(isFocused ? Constants.Colors.primaryBlue : Constants.Colors.textSecondary)
                .frame(width: 20)
                .animation(Constants.Animation.quick, value: isFocused)
            
            // Text Field
            Group {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .keyboardType(keyboardType)
            .textContentType(contentType)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .focused($isFocused)
            
            // Password visibility toggle
            if isSecure {
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? Constants.Images.eye : Constants.Images.eyeSlash)
                        .foregroundColor(Constants.Colors.textSecondary)
                }
            }
        }
        .padding(Constants.UI.padding)
        .background(Constants.Colors.backgroundSecondary)
        .cornerRadius(Constants.UI.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                .stroke(
                    isFocused ? Constants.Colors.primaryBlue : Color.clear,
                    lineWidth: 1
                )
        )
        .animation(Constants.Animation.quick, value: isFocused)
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomTextField(
            placeholder: "Email",
            text: .constant(""),
            icon: Constants.Images.envelope,
            keyboardType: .emailAddress
        )
        
        CustomTextField(
            placeholder: "Password",
            text: .constant(""),
            icon: Constants.Images.lock,
            isSecure: true
        )
    }
    .padding()
}
