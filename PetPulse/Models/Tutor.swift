import Foundation

// MARK: - Tutor
struct Tutor: Identifiable, Codable {
    let id: String?
    let rev: String?
    var nome: String
    var cpf: String
    var email: String
    var telefone: String
    var endereco: String
    let notificacoes: [Notificacao]?
    let pets: [Pet]?
    
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case nome
            case cpf
            case email
            case telefone
            case endereco
            case notificacoes
            case pets
        }
}






