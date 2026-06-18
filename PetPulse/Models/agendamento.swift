//
//  agendamento.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Scheduling (Agendamentos)
struct Scheduling: Identifiable, Codable {
    let id: Int
    var petId: Int
    var petshopId: Int
    var serviceId: Int
    var dataHoraAgendamento: Date
    var statusServico: String
}
