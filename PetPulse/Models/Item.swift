//
//  Item.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation



// MARK: - Item
struct Item: Identifiable, Codable {
    let id: Int
    var petshopId: Int
    var targetSpeciesId: Int
    var nome: String
    var tipo: String
}
