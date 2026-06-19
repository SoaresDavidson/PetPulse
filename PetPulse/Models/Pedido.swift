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
    let rev: String
    var tutorId: Int
    var petshopId: Int
    var dataPedido: Date
    var tipoEntrega: String
    var statusPedido: String
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case tutorId = "tutor_id"
            case petshopId = "petshop_id"
            case dataPedido = "data_pedido"
            case tipoEntrega = "tipo_entrega"
            case statusPedido = "status_pedido"
        }
}
