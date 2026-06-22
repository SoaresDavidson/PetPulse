//
//  Pet.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Pet
struct Pet: Identifiable, Codable {
    let id: String?
    let rev: String?
    var nome: String
    var species: Species
    var raca: String
    var dataNascimento: Date
    var vacinas: [VacinaPet]
    let informacoes_medicas: String
    let sexo: String
    let imagem: String
    
    
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case nome
            case raca
            case sexo
            case dataNascimento = "nasc"
            case informacoes_medicas
            case vacinas
            case imagem
            case species
        }
}
