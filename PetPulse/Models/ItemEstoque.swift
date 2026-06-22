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
    var targetSpeciesId: Int
    var nome: String
    var tipo: String
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case targetSpeciesId = "target_species_id"
            case nome
            case tipo
        }
}
