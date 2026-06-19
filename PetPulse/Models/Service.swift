//
//  Service.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation


// MARK: - Services
struct Service: Identifiable, Codable {
    let id: Int
    let rev: String
    var petshopId: Int
    var nomeServico: String
    var preco: Double
    var duracaoEstimada: Int
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case petshopId = "petshop_id"
            case nomeServico = "nome_servico"
            case preco
            case duracaoEstimada = "duracao_estimada"
        }
}
