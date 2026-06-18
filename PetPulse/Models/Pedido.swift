//
//  Pedido.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

// MARK: - Pedidos
struct Pedido: Identifiable, Codable {
    let id: Int
    var tutorId: Int
    var petshopId: Int
    var dataPedido: Date
    var tipoEntrega: String
    var statusPedido: String
}
