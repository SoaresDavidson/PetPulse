//
//  agendamento.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Scheduling (Agendamentos)
struct Scheduling: Identifiable, Codable {
    let id: Int?
    let rev: String?
    var tutorId: String
    var petId: Int
    var petshopId: String
    var serviceId: Int
    var dataHoraAgendamento: Date
    var statusServico: String
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case tutorId = "tutor_id"
            case petId = "pet_id"
            case petshopId = "petshop_id"
            case serviceId = "service_id"
            case dataHoraAgendamento = "data_hora_agendamento"
            case statusServico = "status_servico"
        }
}
