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
    var pedidoId: Int
    var itemId: Int
    var quantidade: Int
    var precoUnitario: Double // Double é padrão no Swift, mas Decimal também pode ser usado para precisão financeira
}
