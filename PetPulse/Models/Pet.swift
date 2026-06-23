//
//  Pet.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Pet
struct Pet: Identifiable, Codable {
    let id: Int?                 // JSON envia "id" como Int
    let rev: String?             // não aparece no exemplo, manter opcional
    var nome: String
    var species: Species         // mapeado de "especie"
    var raca: String
    var dataNascimento: Date     // mapeado de "data_nascimento" (yyyy-MM-dd)
    var vacinas: [VacinaPet]
    var informacoes_medicas: String
    // Campos não presentes no JSON exemplo devem ser opcionais
    var sexo: String? = nil
    var imagem: String? = nil

    enum CodingKeys: String, CodingKey {
        case id                   // "id"
        case rev = "_rev"
        case nome
        case raca
        case sexo
        case dataNascimento = "data_nascimento"
        case informacoes_medicas
        case vacinas
        case imagem
        case species = "especie"
    }
}
