//
//  PetPulseApp.swift
//  PetPulse
//
//  Created by Turma02-10 on 18/06/26.
//

import SwiftUI

@main
struct PetPulseApp: App {
    @StateObject private var apiConfig = APIConfig.shared
    @StateObject private var petViewModel = PetViewModel()
    @StateObject private var tutorViewModel = TutorViewModel()
    @StateObject private var petshopViewModel = PetshopViewModel()
    @StateObject private var agendamentoViewModel = AgendamentoViewModel()
    @StateObject private var itemPedidoViewModel = ItemPedidoViewModel()
    @StateObject private var notificacaoViewModel = NotificacaoViewModel()

    var body: some Scene {
        WindowGroup {
            TelaInicialView()
                .environmentObject(apiConfig)
                .environmentObject(petViewModel)
                .environmentObject(tutorViewModel)
                .environmentObject(petshopViewModel)
                .environmentObject(agendamentoViewModel)
                .environmentObject(itemPedidoViewModel)
                .environmentObject(notificacaoViewModel)
        }
    }
}
