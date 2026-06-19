//
//  ItemPedido.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation


// MARK: - Itens Pedido
struct ItemPedido: Identifiable, Codable {
    let id: Int
    let rev: String
    var pedidoId: Int
    var itemId: Int
    var quantidade: Int
    var precoUnitario: Double // Double é padrão no Swift, mas Decimal também pode ser usado para precisão financeira
    enum CodingKeys: String, CodingKey {
            case id = "_id"
            case rev = "_rev"
            case pedidoId = "pedido_id"
            case itemId = "item_id"
            case quantidade
            case precoUnitario = "preco_unitario"
        }
}
