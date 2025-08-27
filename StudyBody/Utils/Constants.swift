//
// Constants.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import SwiftUI

struct Constants {
    // MARK: - API Configuration
    struct API {
        static let baseURL = "https://study-body.online:8080"
        static let timeout: Double = 30.0
    }

    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 5
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let largePadding: CGFloat = 24
        
        // TextField
        static let textFieldHeight: CGFloat = 48
        static let textAreaMinHeight: CGFloat = 100
        
        // Button
        static let buttonHeight: CGFloat = 48
        static let smallButtonHeight: CGFloat = 36
        
        // Spacing
        static let smallSpacing: CGFloat = 8
        static let mediumSpacing: CGFloat = 16
        static let largeSpacing: CGFloat = 24
    }

    // MARK: - Colors
    struct Colors {
        static let primaryBlue = Color(red: 0.0, green: 0.47, blue: 0.95)
        static let secondaryBlue = Color(red: 0.4, green: 0.7, blue: 1.0)
        static let errorRed = Color(red: 0.96, green: 0.26, blue: 0.21)
        static let successGreen = Color(red: 0.2, green: 0.78, blue: 0.35)
        static let warningOrange = Color(red: 1.0, green: 0.58, blue: 0.0)
        
        // Text colors
        static let textPrimary = Color.primary
        static let textSecondary = Color.secondary
        static let textTertiary = Color(UIColor.tertiaryLabel)
        
        // Background colors
        static let backgroundPrimary = Color(UIColor.systemBackground)
        static let backgroundSecondary = Color(UIColor.secondarySystemBackground)
        static let backgroundTertiary = Color(UIColor.tertiarySystemBackground)
        
        // Card colors
        static let cardBackground = Color(UIColor.systemBackground)
        static let cardBorder = Color(UIColor.separator)
    }

    // MARK: - Fonts
    struct Fonts {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title1 = Font.title.weight(.semibold)
        static let title2 = Font.title2.weight(.semibold)
        static let title3 = Font.title3.weight(.medium)
        static let headline = Font.headline
        static let body = Font.body
        static let callout = Font.callout
        static let subheadline = Font.subheadline
        static let footnote = Font.footnote
        static let caption = Font.caption
    }

    // MARK: - Animation
    struct Animation {
        static let `default` = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
    }

    // MARK: - Images
    struct Images {
        static let personCircle = "person.circle"
        static let envelope = "envelope"
        static let lock = "lock"
        static let eye = "eye"
        static let eyeSlash = "eye.slash"
        static let plus = "plus"
        static let pencil = "pencil"
        static let trash = "trash"
        static let xmark = "xmark"
        static let checkmark = "checkmark"
        static let magnifyingglass = "magnifyingglass"
        static let gearshape = "gearshape"
        static let listBullet = "list.bullet"
        static let personFill = "person.fill"
        static let briefcase = "briefcase"
        static let briefcaseFill = "briefcase.fill"
    }

    // MARK: - Validation
    struct Validation {
        static let minPasswordLength = 6
        static let maxNameLength = 100
        static let maxDescriptionLength = 1000
        static let maxInterestsLength = 500
    }

    // MARK: - Text
    struct Text {
        struct Login {
            static let title = "Вход"
            static let emailPlaceholder = "Email"
            static let passwordPlaceholder = "Пароль"
            static let loginButton = "Войти"
            static let forgotPassword = "Забыли пароль?"
            static let noAccount = "Нет аккаунта?"
            static let register = "Регистрация"
        }

        struct Register {
            static let title = "Регистрация"
            static let fullNamePlaceholder = "Полное имя"
            static let emailPlaceholder = "Email"
            static let passwordPlaceholder = "Пароль"
            static let confirmPasswordPlaceholder = "Подтвердите пароль"
            static let departmentPlaceholder = "Факультет (необязательно)"
            static let interestsPlaceholder = "Интересы (необязательно)"
            static let registerButton = "Зарегистрироваться"
            static let haveAccount = "Уже есть аккаунт?"
            static let login = "Войти"
        }

        struct Profile {
            static let title = "Профиль"
            static let edit = "Редактировать"
            static let save = "Сохранить"
            static let cancel = "Отмена"
            static let changePassword = "Сменить пароль"
            static let logout = "Выйти"
        }

        struct Vacancies {
            static let allVacancies = "Все вакансии"
            static let myVacancies = "Мои вакансии"
            static let createVacancy = "Создать вакансию"
            static let editVacancy = "Редактировать вакансию"
            static let titlePlaceholder = "Название вакансии"
            static let descriptionPlaceholder = "Описание (необязательно)"
            static let tagsPlaceholder = "Теги через запятую"
            static let save = "Сохранить"
            static let delete = "Удалить"
            static let search = "Поиск вакансий"
        }

        struct Common {
            static let loading = "Загрузка..."
            static let error = "Ошибка"
            static let success = "Успешно"
            static let ok = "OK"
            static let cancel = "Отмена"
            static let save = "Сохранить"
            static let delete = "Удалить"
            static let edit = "Редактировать"
            static let done = "Готово"
            static let retry = "Повторить"
        }
    }
}
