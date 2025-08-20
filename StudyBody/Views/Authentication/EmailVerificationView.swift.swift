//
// EmailVerificationView.swift
// StudyBody
//

import SwiftUI

struct EmailVerificationView: View {
    let email: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "envelope.circle")
                .font(.system(size: 64))
                .foregroundColor(.blue)
            
            Text("Проверьте вашу почту")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Мы отправили на \(email) ссылку для подтверждения регистрации. Перейдите по ссылке из письма для активации аккаунта.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Text("После подтверждения вы сможете войти в приложение.")
                .multilineTextAlignment(.center)
                .font(.subheadline)
        }
        .padding()
    }
}
