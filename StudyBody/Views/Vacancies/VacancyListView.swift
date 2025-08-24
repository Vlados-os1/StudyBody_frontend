import SwiftUI

struct VacancyListView: View {
    @EnvironmentObject var vm: VacancyViewModel
    @State private var showingCreateVacancy = false

    var body: some View {
        NavigationStack {
            Group {
                if vm.isLoading && vm.vacancies.isEmpty {
                    ProgressView("Загрузка вакансий...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if vm.vacancies.isEmpty {
                    emptyStateView
                } else {
                    vacancyListView
                }
            }
            .navigationTitle("Вакансии")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Создать") {
                        showingCreateVacancy = true
                    }
                }
            }
            .sheet(isPresented: $showingCreateVacancy) {
                CreateVacancyView { request in
                    Task {
                        _ = await vm.createVacancy(request)
                    }
                }
            }
            .refreshable {
                await vm.fetchVacancies()
            }
            .alert("Ошибка", isPresented: .constant(vm.errorMessage != nil)) {
                Button("OK") { vm.clearError() }
            } message: {
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            Text("Нет вакансий")
                .font(.title2)
                .fontWeight(.medium)

            Text("Создайте первую вакансию или обновите список")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Создать вакансию") {
                showingCreateVacancy = true
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .padding()
    }

    private var vacancyListView: some View {
        List {
            ForEach(vm.vacancies) { vacancy in
                NavigationLink(destination: VacancyDetailView(vacancy: vacancy)) {
                    VacancyRowView(vacancy: vacancy)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct VacancyRowView: View {
    let vacancy: Vacancy

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(vacancy.title)
                .font(.headline)
                .lineLimit(2)

            Text(vacancy.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)

            HStack {
                Text("Автор: \(vacancy.user.fullName)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text(vacancy.createdAt, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if !vacancy.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vacancy.tagsArray, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.horizontal, 1)
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 4)
    }
}
