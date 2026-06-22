//
//  VacinaPet.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Vacinas Pet
struct VacinaPet: Identifiable, Codable {
    let id: Int?
    let nome: String
    let dataAplicacao: Date
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case nome
            case dataAplicacao = "dataAp"
    }
}
