//
// User.swift
// StudyBodyApp
//
// Created by User on 25/08/2025.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    let email: String
    let fullName: String
    let department: UserDepartment?
    let interests: String?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case fullName
        case department
        case interests
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Максимально гибкое декодирование ID
        if let idString = try? container.decode(String.self, forKey: .id) {
            id = idString
        } else if let idInt = try? container.decode(Int.self, forKey: .id) {
            id = String(idInt)
        } else if let idDouble = try? container.decode(Double.self, forKey: .id) {
            id = String(Int(idDouble))
        } else if let idBool = try? container.decode(Bool.self, forKey: .id) {
            id = String(idBool)
        } else {
            // Если ничего не сработало, попробуем получить как Any и конвертировать
            if let anyValue = try? container.decode(AnyCodable.self, forKey: .id) {
                id = String(describing: anyValue.value)
            } else {
                // В крайнем случае создаем случайный ID
                print("⚠️ Could not decode user ID, generating random ID")
                id = UUID().uuidString
            }
        }
        
        email = try container.decode(String.self, forKey: .email)
        fullName = try container.decode(String.self, forKey: .fullName)
        interests = try container.decodeIfPresent(String.self, forKey: .interests)
        
        // Гибкое декодирование department
        if let departmentString = try? container.decodeIfPresent(String.self, forKey: .department) {
            department = UserDepartment(rawValue: departmentString)
        } else {
            department = nil
        }
    }
}

// Вспомогательная структура для декодирования Any значений
struct AnyCodable: Codable {
    let value: Any
    
    init(_ value: Any) {
        self.value = value
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else {
            value = "unknown"
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        }
    }
}

enum UserDepartment: String, CaseIterable, Codable {
    case iu = "ИУ"
    case mt = "МТ"
    case ibm = "ИБМ"
    case sm = "СМ"
    case fn = "ФН"
    case bmt = "БМТ"
    case rk = "РК"
    case rl = "РЛ"
    case energy = "Э"
    case ur = "ЮР"
    case sgn = "СГН"
    case ling = "Л"

    var displayName: String {
        switch self {
        case .iu: return "ИУ - Информатика и управление"
        case .mt: return "МТ - Машиностроительные технологии"
        case .ibm: return "ИБМ - Инженерный бизнес и менеджмент"
        case .sm: return "СМ - Специальное машиностроение"
        case .fn: return "ФН - Фундаментальные науки"
        case .bmt: return "БМТ - Биомедицинские технологии"
        case .rk: return "РК - Радиоэлектроника и компьютерные технологии"
        case .rl: return "РЛ - Радиотехника и лазерная техника"
        case .energy: return "Э - Энергомашиностроение"
        case .ur: return "ЮР - Юриспруденция"
        case .sgn: return "СГН - Социально-гуманитарные науки"
        case .ling: return "Л - Лингвистика"
        }
    }
}
