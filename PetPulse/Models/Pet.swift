//
//  Pet.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Pet
struct Pet: Identifiable, Codable {
    let id: String
    let rev: String
    var tutorId: Int
    var petshopId: Int? // Opcional, dependendo da regra de negócio (se um pet só existe atrelado a um petshop)
    var speciesId: Int
    var nome: String
    var raca: String
    var dataNascimento: Date
    var informacoesMedicas: String
    
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case tutorId = "tutor_id"
            case petshopId = "petshop_id"
            case speciesId = "species_id"
            case nome
            case raca
            case dataNascimento = "data_nascimento"
            case informacoesMedicas = "informacoes_medicas"
        }
}
