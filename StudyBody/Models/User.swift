//
// User.swift
// StudyBody
//

import Foundation

enum UserDepartment: String, Codable, CaseIterable, Identifiable {
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
    
    var id: String { self.rawValue }
    var title: String { self.rawValue }
}

struct User: Codable, Identifiable {
    var id: UUID
    var email: String
    var fullName: String // backend возвращает full_name
    var department: UserDepartment?
    var interests: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, department, interests
        case fullName = "full_name" // маппинг для backend
    }
}
