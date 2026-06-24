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
    case ave = "ave"
    case roedor = "roedor"
    case outro = "outro"
}

enum tipoEntrega: String, Codable, CaseIterable{
    case presencial = "presencial"
    case delivery = "delivery"
    case retirada = "retirada"
}

enum statusService: String, Codable, CaseIterable{
    case concluido = "concluído"
    case emAtendimento = "Em Atendimento"
    case concluido_entregue = "concluido e entregue"
    case esperando = "esperando ser atendido"
}

extension JSONDecoder.DateDecodingStrategy {
    static let customFlexible: JSONDecoder.DateDecodingStrategy = .custom { decoder in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)
        
        let formatters = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd"
        ].map { format -> DateFormatter in
            let f = DateFormatter()
            f.calendar = Calendar(identifier: .gregorian)
            f.locale = Locale(identifier: "en_US_POSIX")
            f.dateFormat = format
            return f
        }
        
        for formatter in formatters {
            if let date = formatter.date(from: dateStr) {
                return date
            }
        }
        
        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Cannot decode date string \(dateStr)"
        )
    }
}
