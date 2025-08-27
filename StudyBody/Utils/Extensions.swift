//
// Extensions.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI
import Foundation

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self
            .background(Constants.Colors.backgroundPrimary)
            .cornerRadius(Constants.UI.cornerRadius)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButtonStyle() -> some View {
        self
            .buttonStyle(SecondaryButtonStyle())
    }
    
    func destructiveButtonStyle() -> some View {
        self
            .buttonStyle(DestructiveButtonStyle())
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Date Extensions
extension Date {
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear, .month, .year], from: self, to: now)
        
        if let year = components.year, year > 0 {
            return year == 1 ? "год назад" : "\(year) лет назад"
        }
        
        if let month = components.month, month > 0 {
            return month == 1 ? "месяц назад" : "\(month) месяцев назад"
        }
        
        if let week = components.weekOfYear, week > 0 {
            return week == 1 ? "неделю назад" : "\(week) недель назад"
        }
        
        if let day = components.day, day > 0 {
            return day == 1 ? "вчера" : "\(day) дней назад"
        }
        
        if let hour = components.hour, hour > 0 {
            return hour == 1 ? "час назад" : "\(hour) часов назад"
        }
        
        if let minute = components.minute, minute > 0 {
            return minute == 1 ? "минуту назад" : "\(minute) минут назад"
        }
        
        return "только что"
    }
}

// MARK: - Binding Extensions
extension Binding where Value == String {
    func limitTo(_ limit: Int) -> Binding<String> {
        return Binding(
            get: { self.wrappedValue },
            set: { newValue in
                if newValue.count <= limit {
                    self.wrappedValue = newValue
                }
            }
        )
    }
    
    func max(_ limit: Int) -> Binding<String> {
        return limitTo(limit)
    }
}

// MARK: - Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(Constants.UI.padding)
            .background(Constants.Colors.primaryBlue)
            .cornerRadius(Constants.UI.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(Constants.Animation.quick, value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(Constants.Colors.primaryBlue)
            .frame(maxWidth: .infinity)
            .padding(Constants.UI.padding)
            .background(Constants.Colors.primaryBlue.opacity(0.1))
            .cornerRadius(Constants.UI.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Constants.UI.cornerRadius)
                    .stroke(Constants.Colors.primaryBlue, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(Constants.Animation.quick, value: configuration.isPressed)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(Constants.UI.padding)
            .background(Constants.Colors.errorRed)
            .cornerRadius(Constants.UI.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(Constants.Animation.quick, value: configuration.isPressed)
    }
}
