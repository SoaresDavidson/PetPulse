import SwiftUI

struct PetshopInicioView: View {
    @EnvironmentObject var viewModel: PetViewModel
    @EnvironmentObject var AgendamentoViewModel: AgendamentoViewModel
    @EnvironmentObject var TutorViewModel: TutorViewModel
    @StateObject private var serviceViewModel = ServiceViewModel()
    @State private var showPetCreatedAlert = false

    private var todosOsPets: [Pet] {
        TutorViewModel.tutores.compactMap { $0.pets }.flatMap { $0 }
    }

    private var agendamentosAguardando: [Scheduling] {
        let pets = todosOsPets
        return AgendamentoViewModel.agendamentos
            .filter { $0.statusServico == .concluido }
            .sorted { ag1, ag2 in
                let nome1 = pets.first(where: { $0.id == ag1.petId })?.nome ?? ""
                let nome2 = pets.first(where: { $0.id == ag2.petId })?.nome ?? ""
                return nome1.localizedCaseInsensitiveCompare(nome2) == .orderedAscending
            }
    }

    private var agendamentosEntregues: [Scheduling] {
        let pets = todosOsPets
        return AgendamentoViewModel.agendamentos
            .filter { $0.statusServico == .concluido_entregue }
            .sorted { ag1, ag2 in
                let nome1 = pets.first(where: { $0.id == ag1.petId })?.nome ?? ""
                let nome2 = pets.first(where: { $0.id == ag2.petId })?.nome ?? ""
                return nome1.localizedCaseInsensitiveCompare(nome2) == .orderedAscending
            }
    }

    private func obterPetAtendimento(para agendamento: Scheduling) -> PetAtendimento? {
        guard let pet = todosOsPets.first(where: { $0.id == agendamento.petId }) else {
            return nil
        }
        
        let serviceName: String
        let servicePrice: Double
        
        if let service = serviceViewModel.services.first(where: { $0.id == agendamento.serviceId }) {
            serviceName = service.nomeServico
            servicePrice = service.preco
        } else {
            switch agendamento.serviceId {
            case 1:
                serviceName = "Banho"
                servicePrice = 80.0
            case 2:
                serviceName = "Tosa"
                servicePrice = 90.0
            case 3:
                serviceName = "Consulta"
                servicePrice = 120.0
            case 4:
                serviceName = "Vacina"
                servicePrice = 50.0
            default:
                serviceName = "Serviço \(agendamento.serviceId)"
                servicePrice = 100.0
            }
        }
        
        return PetAtendimento(
            nome: pet.nome,
            raca: pet.raca,
            imagem: pet.imagem ?? "",
            servicos: [serviceName],
            valor: servicePrice,
            entregue: agendamento.statusServico == .concluido_entregue
        )
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:25) {
                    // SALDO DO DIA
                    VStack(spacing:10) {
                        Text("Saldo do dia")
                            .font(.headline)
                            .foregroundColor(
                                .white.opacity(0.9)
                            )
                        Text("R$ 0,00")
                            .font(
                                .system(
                                    size:36,
                                    weight:.bold
                                )
                            )
                            .foregroundColor(
                                .white
                            )
                    }
                    .frame(
                        maxWidth:.infinity
                    )
                    .frame(
                        height:170
                    )
                    .background(
                        Color.blue
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius:30
                        )
                    )
                    // CADASTRAR NOVO PET
                    NavigationLink {
                        CadastroPetView()
                    } label: {
                        HStack {
                            Image(
                                systemName:"plus.circle.fill"
                            )
                            Text("Cadastrar novo pet")
                                .font(.headline)
                        }
                        .foregroundColor(
                            .white
                        )
                        .frame(
                            maxWidth:.infinity
                        )
                        .padding(.vertical,16)
                        .background(
                            Color.green
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:20
                            )
                        )
                    }
                    // CARDS DE QUANTIDADE
                    HStack(spacing:15) {
                        VStack(spacing:10) {
                            Text("Pets atendidos")
                                .font(.headline)
                                .foregroundColor(
                                    .white
                                )
                            Text(
                                "\(agendamentosEntregues.count)"
                            )
                            .font(
                                .system(
                                    size:35,
                                    weight:.bold
                                )
                            )
                            .foregroundColor(
                                .white
                            )
                        }
                        .frame(
                            maxWidth:.infinity
                        )
                        .frame(
                            height:140
                        )
                        .background(
                            Color.blue
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:25
                            )
                        )
                        VStack(spacing:10) {
                            Text("Restantes")
                                .font(.headline)
                                .foregroundColor(
                                    .white
                                )
                            Text(
                                "\(agendamentosAguardando.count)"
                            )
                            .font(
                                .system(
                                    size:35,
                                    weight:.bold
                                )
                            )
                            .foregroundColor(
                                .white
                            )
                        }
                        .frame(
                            maxWidth:.infinity
                        )
                        .frame(
                            height:140
                        )
                        .background(
                            Color.orange
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:25
                            )
                        )

                    }
                    // AGUARDANDO ENTREGA
                    VStack(
                        alignment:.leading,
                        spacing:15
                    ) {
                        Text("Aguardando entrega")
                            .font(
                                .title2.bold()
                            )
                        ForEach(
                            agendamentosAguardando
                        ) { agendamento in
                            if let pet = obterPetAtendimento(para: agendamento) {
                                PetEntregaCardView(
                                    pet:pet,
                                    entregue:false
                                ) {
                                    Task {
                                        var updated = agendamento
                                        updated.statusServico = .concluido_entregue
                                        await AgendamentoViewModel.putAgendamento(agendamento: updated)
                                        await AgendamentoViewModel.getAgendamentos()
                                    }
                                }
                            }
                        }
                    }
                    // ENTREGUES
                    VStack(
                        alignment:.leading,
                        spacing:15
                    ) {
                        Text("Entregues")
                            .font(
                                .title2.bold()
                            )
                            .padding(
                                .top
                            )
                        ForEach(
                            agendamentosEntregues
                        ) { agendamento in
                            if let pet = obterPetAtendimento(para: agendamento) {
                                PetEntregaCardView(
                                    pet:pet,
                                    entregue:true,
                                    acao:{
                                    },
                                    desfazer:{
                                        Task {
                                            var updated = agendamento
                                            updated.statusServico = .concluido
                                            await AgendamentoViewModel.putAgendamento(agendamento: updated)
                                            await AgendamentoViewModel.getAgendamentos()
                                        }
                                    }
                                )
                                .opacity(
                                    0.45
                                )
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(
                "Home"
            )
            .task {
                await TutorViewModel.getTutores()
                await AgendamentoViewModel.getAgendamentos()
                await serviceViewModel.getServices()
            }
            .onChange(of: viewModel.responseMessage) { _, newValue in
                if newValue.contains("Sucesso! Pet criado") {
                    showPetCreatedAlert = true
                }
            }
            .alert("Sucesso", isPresented: $showPetCreatedAlert) {
                Button("OK") {
                    viewModel.responseMessage = ""
                }
            } message: {
                Text("Pet cadastrado com sucesso!")
            }
        }
    }
}
