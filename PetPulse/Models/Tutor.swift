import Foundation

// MARK: - Tutor
struct Tutor: Identifiable, Codable {
    let id: String
    let rev: String
    var nome: String
    var cpf: String
    var email: String
    var telefone: String
    var endereco: String
    
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case nome
            case cpf
            case email
            case telefone
            case endereco
        }
}






