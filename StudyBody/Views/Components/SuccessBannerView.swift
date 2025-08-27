//
//  SuccessBannerView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct SuccessBannerView: View {
    let message: String
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Constants.Colors.successGreen)
                
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
            .background(Constants.Colors.successGreen.opacity(0.1))
            .cornerRadius(Constants.UI.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .stroke(Constants.Colors.successGreen.opacity(0.3), lineWidth: 1)
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
        SuccessBannerView(
            message: "Данные успешно сохранены",
            isVisible: .constant(true)
        )
        
        SuccessBannerView(
            message: "Ваша вакансия была успешно опубликована и теперь доступна для просмотра",
            isVisible: .constant(true)
        )
    }
    .padding()
}
