//
//  Validators.swift
//  StudyBodyApp
//
//  Created by User on 25/08/2025.
//

import Foundation

struct Validators {
    
    // MARK: - Email Validation
    static func validateEmail(_ email: String) -> ValidationResult {
        let trimmedEmail = email.trimmed
        
        guard !trimmedEmail.isEmpty else {
            return .invalid("Email не может быть пустым")
        }
        
        guard trimmedEmail.isValidEmail else {
            return .invalid("Неверный формат email")
        }
        
        return .valid
    }
    
    // MARK: - Password Validation
    static func validatePassword(_ password: String) -> ValidationResult {
        guard !password.isEmpty else {
            return .invalid("Пароль не может быть пустым")
        }
        
        guard password.count >= Constants.Validation.minPasswordLength else {
            return .invalid("Пароль должен содержать минимум \(Constants.Validation.minPasswordLength) символов")
        }
        
        return .valid
    }
    
    // MARK: - Password Confirmation Validation
    static func validatePasswordConfirmation(_ password: String, _ confirmation: String) -> ValidationResult {
        guard !confirmation.isEmpty else {
            return .invalid("Подтвердите пароль")
        }
        
        guard password == confirmation else {
            return .invalid("Пароли не совпадают")
        }
        
        return .valid
    }
    
    // MARK: - Name Validation
    static func validateName(_ name: String) -> ValidationResult {
        let trimmedName = name.trimmed
        
        guard !trimmedName.isEmpty else {
            return .invalid("Имя не может быть пустым")
        }
        
        guard trimmedName.count <= Constants.Validation.maxNameLength else {
            return .invalid("Имя слишком длинное (максимум \(Constants.Validation.maxNameLength) символов)")
        }
        
        return .valid
    }
    
    // MARK: - Vacancy Title Validation
    static func validateVacancyTitle(_ title: String) -> ValidationResult {
        let trimmedTitle = title.trimmed
        
        guard !trimmedTitle.isEmpty else {
            return .invalid("Название вакансии не может быть пустым")
        }
        
        guard trimmedTitle.count <= Constants.Validation.maxNameLength else {
            return .invalid("Название слишком длинное (максимум \(Constants.Validation.maxNameLength) символов)")
        }
        
        return .valid
    }
    
    // MARK: - Description Validation
    static func validateDescription(_ description: String?) -> ValidationResult {
        guard let description = description, !description.trimmed.isEmpty else {
            return .valid // Description is optional
        }
        
        guard description.count <= Constants.Validation.maxDescriptionLength else {
            return .invalid("Описание слишком длинное (максимум \(Constants.Validation.maxDescriptionLength) символов)")
        }
        
        return .valid
    }
    
    // MARK: - Interests Validation
    static func validateInterests(_ interests: String?) -> ValidationResult {
        guard let interests = interests, !interests.trimmed.isEmpty else {
            return .valid // Interests are optional
        }
        
        guard interests.count <= Constants.Validation.maxInterestsLength else {
            return .invalid("Интересы слишком длинные (максимум \(Constants.Validation.maxInterestsLength) символов)")
        }
        
        return .valid
    }
    
    // MARK: - Tags Validation
    static func validateTags(_ tagsString: String?) -> ValidationResult {
        guard let tagsString = tagsString, !tagsString.trimmed.isEmpty else {
            return .valid // Tags are optional
        }
        
        let tags = tagsString.components(separatedBy: ",").map { $0.trimmed }
        
        // Check if any tag is empty after trimming
        if tags.contains(where: { $0.isEmpty }) {
            return .invalid("Теги не могут быть пустыми")
        }
        
        // Check total length
        if tagsString.count > Constants.Validation.maxInterestsLength {
            return .invalid("Теги слишком длинные (максимум \(Constants.Validation.maxInterestsLength) символов)")
        }
        
        return .valid
    }
    
    // MARK: - Registration Form Validation
    static func validateRegistrationForm(
        email: String,
        fullName: String,
        password: String,
        confirmPassword: String,
        interests: String?
    ) -> ValidationResult {
        
        let emailValidation = validateEmail(email)
        if case .invalid = emailValidation { return emailValidation }
        
        let nameValidation = validateName(fullName)
        if case .invalid = nameValidation { return nameValidation }
        
        let passwordValidation = validatePassword(password)
        if case .invalid = passwordValidation { return passwordValidation }
        
        let confirmPasswordValidation = validatePasswordConfirmation(password, confirmPassword)
        if case .invalid = confirmPasswordValidation { return confirmPasswordValidation }
        
        let interestsValidation = validateInterests(interests)
        if case .invalid = interestsValidation { return interestsValidation }
        
        return .valid
    }
    
    // MARK: - Login Form Validation
    static func validateLoginForm(email: String, password: String) -> ValidationResult {
        let emailValidation = validateEmail(email)
        if case .invalid = emailValidation { return emailValidation }
        
        let passwordValidation = validatePassword(password)
        if case .invalid = passwordValidation { return passwordValidation }
        
        return .valid
    }
    
    // MARK: - Vacancy Form Validation
    static func validateVacancyForm(
        title: String,
        description: String?,
        tags: String?
    ) -> ValidationResult {
        
        let titleValidation = validateVacancyTitle(title)
        if case .invalid = titleValidation { return titleValidation }
        
        let descriptionValidation = validateDescription(description)
        if case .invalid = descriptionValidation { return descriptionValidation }
        
        let tagsValidation = validateTags(tags)
        if case .invalid = tagsValidation { return tagsValidation }
        
        return .valid
    }
}

// MARK: - ValidationResult Enum
enum ValidationResult {
    case valid
    case invalid(String)
    
    var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .valid:
            return nil
        case .invalid(let message):
            return message
        }
    }
}
