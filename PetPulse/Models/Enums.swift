//
//  Species.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import Foundation

enum Species: String, Codable, CaseIterable{
    case cachorro = "cachorro"
    case gato = "gato"
}

enum tipoEntrega: String, Codable, CaseIterable{
    case presecial = "presencial"
    case delivery = "delivery"
}
