//
//  VacinaPet.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Vacinas Pet
struct VacinaPet: Identifiable, Codable {
    let id: Int
    var petId: Int
    var nomeVacina: String
    var dataAplicacao: Date
}
