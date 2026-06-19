//
//  PetShop.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation


// MARK: - Petshop
struct Petshop: Identifiable, Codable {
    let id: Int
    let rev: String
    var nome: String
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case nome
        }
}
