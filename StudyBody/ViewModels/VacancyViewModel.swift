//
// VacancyViewModel.swift
// StudyBody
//

import Foundation
import SwiftUI

@MainActor
final class VacancyViewModel: ObservableObject {
    @Published var vacancies: [Vacancy] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let networkService = NetworkService.shared
    
    // MARK: – Загрузка списка
    
    func fetchVacancies() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        // TODO: Реализовать endpoints для вакансий на backend
        // Пока используем моковые данные
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // Имитация загрузки
        
        self.vacancies = createMockVacancies()
    }
    
    // MARK: – Создание новой вакансии
    
    func createVacancy(_ vacancy: Vacancy) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        // TODO: Реализовать создание вакансии на backend
        // Пока добавляем локально
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        self.vacancies.insert(vacancy, at: 0)
        
        print("📌 Вакансия добавлена локально (мок)")
        
        return true
    }
    
    private func createMockVacancies() -> [Vacancy] {
        return [
            Vacancy(
                id: UUID(),
                title: "Ищу дизайнера в pet-проект",
                summary: "Собираю мобильную команду для приложения по учёту привычек. Нужен дизайнер интерфейсов.",
                authorName: "Даша UIcraft",
                createdAt: Date(),
                tags: ["Design", "Figma", "UI/UX"]
            ),
            Vacancy(
                id: UUID(),
                title: "Backend-разработчик в iOS-команду",
                summary: "Пишем pet-приложение по обмену книгами. Используем Firebase, хотим перейти на Vapor.",
                authorName: "Сергей Backendов",
                createdAt: Date().addingTimeInterval(-3600 * 24),
                tags: ["Backend", "Swift", "Vapor"]
            ),
            Vacancy(
                id: UUID(),
                title: "Ищу iOS разработчика",
                summary: "Разрабатываем мобильное приложение для изучения иностранных языков. Нужен опытный iOS разработчик.",
                authorName: "Анна Мобайлова",
                createdAt: Date().addingTimeInterval(-3600 * 48),
                tags: ["iOS", "SwiftUI", "Education"]
            )
        ]
    }
    
    func clearError() {
        errorMessage = nil
    }
}
