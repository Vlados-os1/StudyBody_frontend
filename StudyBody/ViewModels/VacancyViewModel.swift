//
// VacancyViewModel.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class VacancyViewModel: ObservableObject {
    @Published var allVacancies: [Vacancy] = []
    @Published var myVacancies: [Vacancy] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    
    private let networkManager = NetworkManager.shared
    private let keychain = KeychainManager.shared

    // MARK: - Fetch All Vacancies
    func fetchAllVacancies() async {
        guard let token = keychain.getToken() else {
            errorMessage = "Не авторизован"
            return
        }
        
        isLoading = true
        clearMessages()
        
        do {
            let vacancies = try await networkManager.getAllVacancies(token: token)
            allVacancies = vacancies
        } catch {
            errorMessage = error.localizedDescription
            allVacancies = []
        }
        
        isLoading = false
    }

    // MARK: - Fetch My Vacancies
    func fetchMyVacancies() async {
        guard let token = keychain.getToken() else {
            errorMessage = "Не авторизован"
            return
        }
        
        isLoading = true
        clearMessages()
        
        do {
            let vacancies = try await networkManager.getMyVacancies(token: token)
            myVacancies = vacancies
        } catch {
            errorMessage = error.localizedDescription
            myVacancies = []
        }
        
        isLoading = false
    }

    // MARK: - Create Vacancy
    func createVacancy(title: String, description: String?, tags: [String]) async -> Bool {
        guard let token = keychain.getToken() else {
            errorMessage = "Не авторизован"
            return false
        }
        
        guard !title.isEmpty else {
            errorMessage = "Заголовок не может быть пустым"
            return false
        }

        isLoading = true
        clearMessages()
        
        let tagsString = tags.isEmpty ? nil : tags.joined(separator: ",")
        let request = CreateVacancyRequest(
            title: title,
            description: description,
            tags: tagsString
        )

        do {
            let vacancy = try await networkManager.createVacancy(token: token, request: request)
            successMessage = "Вакансия успешно создана"
            // Add the new vacancy to myVacancies
            myVacancies.insert(vacancy, at: 0)
            // Also refresh all vacancies if needed
            Task {
                await fetchAllVacancies()
            }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Update Vacancy
    func updateVacancy(id: String, title: String?, description: String?, tags: [String]?) async -> Bool {
        guard let token = keychain.getToken() else {
            errorMessage = "Не авторизован"
            return false
        }
        
        isLoading = true
        clearMessages()
        
        let tagsString: String? = {
            if let tags = tags {
                return tags.isEmpty ? nil : tags.joined(separator: ",")
            }
            return nil
        }()
        
        let request = UpdateVacancyRequest(
            title: title,
            description: description,
            tags: tagsString
        )

        do {
            let response = try await networkManager.updateVacancy(token: token, id: id, request: request)
            successMessage = response.msg
            // Refresh vacancies to get updated data
            Task {
                await fetchMyVacancies()
                await fetchAllVacancies()
            }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Delete Vacancy
    func deleteVacancy(id: String) async -> Bool {
        guard let token = keychain.getToken() else {
            errorMessage = "Не авторизован"
            return false
        }
        
        isLoading = true
        clearMessages()
        
        do {
            let response = try await networkManager.deleteVacancy(token: token, id: id)
            successMessage = response.msg
            // Remove from local arrays
            myVacancies.removeAll { $0.id == id }
            allVacancies.removeAll { $0.id == id }
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
            return false
        }
    }

    // MARK: - Get Vacancy by ID
    func getVacancy(id: String) async -> Vacancy? {
        guard let token = keychain.getToken() else {
            errorMessage = "Не авторизован"
            return nil
        }
        
        do {
            let vacancy = try await networkManager.getVacancy(token: token, id: id)
            return vacancy
        } catch {
            errorMessage = error.localizedDescription
            return nil
        }
    }

    // MARK: - Search and Filter
    func searchVacancies(query: String) -> [Vacancy] {
        guard !query.isEmpty else { return allVacancies }
        
        let lowercasedQuery = query.lowercased()
        return allVacancies.filter { vacancy in
            vacancy.title.lowercased().contains(lowercasedQuery) ||
            vacancy.description?.lowercased().contains(lowercasedQuery) == true ||
            vacancy.tags?.lowercased().contains(lowercasedQuery) == true ||
            vacancy.user.fullName.lowercased().contains(lowercasedQuery)
        }
    }

    func filterVacanciesByDepartment(department: UserDepartment?) -> [Vacancy] {
        guard let department = department else { return allVacancies }
        return allVacancies.filter { vacancy in
            vacancy.user.department == department
        }
    }

    // MARK: - Utility
    private func clearMessages() {
        errorMessage = nil
        successMessage = nil
    }

    func clearAllMessages() {
        clearMessages()
    }

    func refreshData() async {
        await fetchAllVacancies()
        await fetchMyVacancies()
    }

    // MARK: - Helper Methods
    func canEditVacancy(_ vacancy: Vacancy, currentUserId: String?) -> Bool {
        guard let currentUserId = currentUserId else { return false }
        return vacancy.user.id == currentUserId
    }

    func getVacancyCount(for userId: String) -> Int {
        return allVacancies.filter { $0.user.id == userId }.count
    }
}
