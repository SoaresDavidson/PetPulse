//
//  VacinaPet.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Vacinas Pet
struct VacinaPet: Identifiable, Codable {
    let id: Int?                 // o JSON não mostrou _id; se não existir, pode ser sempre nil
    let nome: String             // "nome_vacina"
    let dataAplicacao: Date      // "data_aplicacao" (yyyy-MM-dd)

    enum CodingKeys: String, CodingKey {
        case id
        case nome = "nome_vacina"
        case dataAplicacao = "data_aplicacao"
    }
}
