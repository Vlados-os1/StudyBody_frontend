import Foundation
import SwiftUI

@MainActor
final class VacancyViewModel: ObservableObject {
    @Published var vacancies: [Vacancy] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let networkService = NetworkService.shared

    func fetchVacancies() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let fetchedVacancies: [Vacancy] = try await networkService.get(
                endpoint: "/api/vacancies",
                requiresAuth: true,
                responseType: [Vacancy].self
            )
            self.vacancies = fetchedVacancies
        } catch {
            errorMessage = ErrorHandler.getUserFriendlyMessage(from: error)
        }
    }
    
    func createVacancy(_ request: VacancyCreateRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let newVacancy: Vacancy = try await networkService.post(
                endpoint: "/api/main/create_vacancy",
                body: request,
                requiresAuth: true,
                responseType: Vacancy.self
            )
            self.vacancies.insert(newVacancy, at: 0)
            return true
        } catch {
            errorMessage = ErrorHandler.getUserFriendlyMessage(from: error)
            return false
        }
    }
    
    func updateVacancy(id: UUID, request: VacancyUpdateRequest) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            let updatedVacancy: Vacancy = try await networkService.patch(
                endpoint: "/api/vacancy/\(id)",
                body: request,
                requiresAuth: true,
                responseType: Vacancy.self
            )
            
            if let index = vacancies.firstIndex(where: { $0.id == id }) {
                vacancies[index] = updatedVacancy
            }
            return true
        } catch {
            errorMessage = ErrorHandler.getUserFriendlyMessage(from: error)
            return false
        }
    }
    
    func deleteVacancy(id: UUID) async -> Bool {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await networkService.delete(
                endpoint: "/api/vacancy/\(id)",
                requiresAuth: true
            )
            
            vacancies.removeAll { $0.id == id }
            return true
        } catch {
            errorMessage = ErrorHandler.getUserFriendlyMessage(from: error)
            return false
        }
    }
    
    func clearError() {
        errorMessage = nil
    }
}
