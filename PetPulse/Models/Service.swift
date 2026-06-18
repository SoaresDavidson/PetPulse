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
    var petshopId: Int
    var nomeServico: String
    var preco: Double
    var duracaoEstimada: Int
}
