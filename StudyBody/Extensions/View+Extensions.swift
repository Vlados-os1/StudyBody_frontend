//
// View+Extensions.swift
// StudyBody
//

import SwiftUI

extension View {
    /// Применяет модификатор условно
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    /// Скрывает клавиатуру при нажатии на пустое место
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Применяет модификатор с анимацией
    func animatedChange<V: Equatable>(_ value: V) -> some View {
        self.animation(.easeInOut(duration: 0.3), value: value)
    }
}

extension String {
    /// Проверяет валидность email
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Проверяет сильность пароля
    var isStrongPassword: Bool {
        return self.count >= 8 &&
               self.contains(where: { $0.isLetter }) &&
               self.contains(where: { $0.isNumber })
    }
}

extension Task where Success == Never, Failure == Never {
    /// Задержка с возможностью отмены
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
