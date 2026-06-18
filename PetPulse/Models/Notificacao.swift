//
//  Notificacao.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation


// MARK: - Notificacoes
struct Notificacao: Identifiable, Codable {
    let id: Int
    var tutorId: Int
    var petshopId: Int
    var titulo: String
    var mensagem: String
    var dataEnvio: Date
    var lida: Bool
}
