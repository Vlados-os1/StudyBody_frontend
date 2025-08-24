import SwiftUI

struct VacancyDetailView: View {
    let vacancy: Vacancy

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(vacancy.title)
                    .font(.title2)
                    .bold()

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "person.circle")
                            .foregroundColor(.blue)
                        Text(vacancy.user.fullName)
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }

                    if let department = vacancy.user.department {
                        HStack {
                            Image(systemName: "building.2")
                                .foregroundColor(.secondary)
                            Text("Департамент: \(department.title)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    if let interests = vacancy.user.interests {
                        HStack {
                            Image(systemName: "star.circle")
                                .foregroundColor(.secondary)
                            Text("Интересы: \(interests)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.systemGray6))
                .cornerRadius(8)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Описание")
                        .font(.headline)

                    Text(vacancy.description)
                        .font(.body)
                }

                if !vacancy.tags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Теги")
                            .font(.headline)

                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                            ForEach(vacancy.tagsArray, id: \.self) { tag in
                                Text(tag)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.secondary)
                        Text("Создано: \(vacancy.createdAt, style: .date)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                        Text("Обновлено: \(vacancy.updatedAt, style: .relative)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Подробности")
        .navigationBarTitleDisplayMode(.inline)
    }
}
