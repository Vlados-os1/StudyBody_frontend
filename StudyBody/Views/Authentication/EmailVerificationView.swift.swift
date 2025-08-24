//
// EmailVerificationView.swift
// StudyBody
//

import SwiftUI

struct EmailVerificationView: View {
    let email: String
    let onResendEmail: () -> Void
    let onGoToLogin: () -> Void

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

            Button("Отправить письмо повторно") {
                onResendEmail()
            }
            .font(.headline)
            .foregroundColor(.blue)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)

            Button("Перейти на страницу входа") {
                onGoToLogin()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 50)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.top)
        }
        .padding()
    }
}
