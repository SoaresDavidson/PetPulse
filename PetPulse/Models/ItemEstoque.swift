//
//  Item.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation



// MARK: - Item
struct ItemEstoque: Identifiable, Codable {
    let id: Int?
    let rev: String?
    var targetSpecies: Species
    var nome: String
    var tipo: String
    enum CodingKeys: String, CodingKey {
            case id
            case rev = "_rev"
            case targetSpecies = "target_species"
            case nome
            case tipo
        }
}
