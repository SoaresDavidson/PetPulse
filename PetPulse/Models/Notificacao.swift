//
//  Notificacao.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation


// MARK: - Notificacoes
struct Notificacao: Identifiable, Codable {
    let id: Int?
    let rev: String?
    var petshopId: String
    var titulo: String
    var mensagem: String
    var dataEnvio: Date
    var lida: Bool
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case petshopId = "petshop_id"
            case titulo
            case mensagem
            case dataEnvio = "data_envio"
            case lida
        }
}
