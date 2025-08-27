//
//  LoadingView.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import SwiftUI

struct LoadingView: View {
    let text: String
    
    init(text: String = "Загрузка...") {
        self.text = text
    }
    
    var body: some View {
        VStack(spacing: Constants.UI.mediumSpacing) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(Constants.Colors.primaryBlue)
            
            Text(text)
                .font(Constants.Fonts.callout)
                .foregroundColor(Constants.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Constants.Colors.backgroundPrimary)
    }
}

struct LoadingOverlay: View {
    let isLoading: Bool
    let text: String
    
    init(isLoading: Bool, text: String = "Загрузка...") {
        self.isLoading = isLoading
        self.text = text
    }
    
    var body: some View {
        if isLoading {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: Constants.UI.mediumSpacing) {
                    ProgressView()
                        .scaleEffect(1.2)
                        .tint(.white)
                    
                    Text(text)
                        .font(Constants.Fonts.callout)
                        .foregroundColor(.white)
                }
                .padding(Constants.UI.largePadding)
                .background(Color.black.opacity(0.8))
                .cornerRadius(Constants.UI.cornerRadius)
            }
            .transition(.opacity)
        }
    }
}

#Preview {
    VStack {
        LoadingView(text: "Загрузка вакансий...")
            .frame(height: 200)
        
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 200)
            
            LoadingOverlay(isLoading: true, text: "Сохранение...")
        }
    }
}
