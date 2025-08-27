//
//  ErrorBannerView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct ErrorBannerView: View {
    let message: String
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(Constants.Colors.errorRed)
                
                Text(message)
                    .font(Constants.Fonts.callout)
                    .foregroundColor(Constants.Colors.textPrimary)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button {
                    withAnimation(Constants.Animation.quick) {
                        isVisible = false
                    }
                } label: {
                    Image(systemName: Constants.Images.xmark)
                        .foregroundColor(Constants.Colors.textSecondary)
                        .font(.caption)
                }
            }
            .padding(Constants.UI.padding)
            .background(Constants.Colors.errorRed.opacity(0.1))
            .cornerRadius(Constants.UI.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .stroke(Constants.Colors.errorRed.opacity(0.3), lineWidth: 1)
            )
            .transition(.asymmetric(
                insertion: .move(edge: .top).combined(with: .opacity),
                removal: .opacity
            ))
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ErrorBannerView(
            message: "Произошла ошибка при загрузке данных",
            isVisible: .constant(true)
        )
        
        ErrorBannerView(
            message: "Очень длинное сообщение об ошибке, которое может занимать несколько строк и должно корректно отображаться",
            isVisible: .constant(true)
        )
    }
    .padding()
}
