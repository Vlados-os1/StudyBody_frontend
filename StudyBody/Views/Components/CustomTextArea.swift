//
//  CustomTextArea.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct CustomTextArea: View {
    let placeholder: String
    @Binding var text: String
    let maxLength: Int
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .trailing, spacing: Constants.UI.smallSpacing) {
            ZStack(alignment: .topLeading) {
                // Background
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .fill(Constants.Colors.backgroundSecondary)
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                            .stroke(
                                isFocused ? Constants.Colors.primaryBlue : Color.clear,
                                lineWidth: 1
                            )
                    )
                    .frame(minHeight: Constants.UI.textAreaMinHeight)
                
                // Placeholder
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Constants.Colors.textTertiary)
                        .padding(Constants.UI.padding)
                        .allowsHitTesting(false)
                }
                
                // Text Editor
                TextEditor(text: $text)
                    .padding(Constants.UI.padding - 4) // Adjust for TextEditor padding
                    .background(Color.clear)
                    .focused($isFocused)
                    .scrollContentBackground(.hidden)
            }
            .animation(Constants.Animation.quick, value: isFocused)
            
            // Character count
            HStack {
                Spacer()
                Text("\(text.count)/\(maxLength)")
                    .font(Constants.Fonts.caption)
                    .foregroundColor(
                        text.count > maxLength ?
                        Constants.Colors.errorRed :
                        Constants.Colors.textTertiary
                    )
            }
        }
        .onChange(of: text) { _, newValue in
            if newValue.count > maxLength {
                text = String(newValue.prefix(maxLength))
            }
        }
    }
}

#Preview {
    CustomTextArea(
        placeholder: "Расскажите о себе...",
        text: .constant(""),
        maxLength: 500
    )
    .padding()
}
