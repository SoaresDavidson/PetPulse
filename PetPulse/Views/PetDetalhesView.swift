import SwiftUI

struct PetDetalhesView: View {
    @EnvironmentObject var agendamentoViewModel: AgendamentoViewModel
    @EnvironmentObject var petshopViewModel: PetshopViewModel
    @EnvironmentObject var tutorViewModel: TutorViewModel
    @EnvironmentObject var petViewModel: PetViewModel
    
    var pet: Pet
    @State private var isShowingEditSheet = false
    
    // Dynamic reactive computed property to always show the latest pet details
    private var currentPet: Pet {
        if let tutor = tutorViewModel.tutorLogado,
           let p = tutor.pets?.first(where: { $0.id == pet.id }) {
            return p
        }
        if let p = tutorViewModel.tutores.compactMap({ $0.pets }).flatMap({ $0 }).first(where: { $0.id == pet.id }) {
            return p
        }
        return pet
    }
    
    private var tutorId: String {
        if let tutor = tutorViewModel.tutorLogado,
           tutor.pets?.contains(where: { $0.id == pet.id }) == true {
            return tutor.id ?? "tutor_1782166739059"
        }
        if let tutor = tutorViewModel.tutores.first(where: { $0.pets?.contains(where: { $0.id == pet.id }) == true }) {
            return tutor.id ?? "tutor_1782166739059"
        }
        return "tutor_1782166739059"
    }

    private var servicosRealizados: [String] {
        guard let petId = currentPet.id else { return [] }
        
        let agendamentosDoPet = agendamentoViewModel.agendamentos.filter {
            $0.petId == petId &&
            ($0.statusServico == .concluido || $0.statusServico == .concluido_entregue)
        }
        
        var nomes: [String] = []
        for ag in agendamentosDoPet {
            if let petshop = petshopViewModel.petshops.first(where: { $0.id == ag.petshopId }),
            let service = petshop.servicos.first(where: { $0.id == ag.serviceId }) {
                nomes.append(service.nomeServico)
            }
        }
        
        return Array(Set(nomes)).sorted()
    }

    private var ultimoServico: String? {
        guard let petId = currentPet.id else { return nil }
        
        let ultimoAgendamento = agendamentoViewModel.agendamentos
            .filter { $0.petId == petId && ($0.statusServico == .concluido || $0.statusServico == .concluido_entregue) }
            .sorted(by: { $0.dataHoraAgendamento > $1.dataHoraAgendamento })
            .first
            
        guard let ag = ultimoAgendamento else { return nil }
        
        if let petshop = petshopViewModel.petshops.first(where: { $0.id == ag.petshopId }),
        let service = petshop.servicos.first(where: { $0.id == ag.serviceId }) {
            return service.nomeServico
        }
        
        return nil
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // PHOTO
                ZStack(alignment: .bottomTrailing) {
                    if let imagem = currentPet.imagem, !imagem.isEmpty {
                        Image(imagem)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 32))
                            .shadow(color: Color.black.opacity(0.1), radius: 8, y: 4)
                    } else {
                        RoundedRectangle(cornerRadius: 32)
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 150, height: 150)
                            .overlay(
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 44))
                                    .foregroundColor(.gray.opacity(0.5))
                            )
                    }
                }
                
                // NAME & DESCRIPTION
                VStack(spacing: 6) {
                    Text(currentPet.nome)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.blue)
                    
                    HStack(spacing: 8) {
                        Text(currentPet.species.rawValue.capitalized)
                            .font(.system(size: 13, weight: .medium))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Text(currentPet.raca)
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    }
                }
                
                // GENERAL PET DETAILS
                VStack(alignment: .leading, spacing: 14) {
                    Text("Dados do Pet")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 12) {
                        DetailItemRow(title: "Sexo", value: currentPet.sexo ?? "Não informado", icon: "hare")
                        Divider()
                        DetailItemRow(title: "Nascimento", value: currentPet.dataNascimento.formatted(date: .long, time: .omitted), icon: "calendar")
                        Divider()
                        DetailItemRow(title: "Histórico Médico", value: currentPet.informacoes_medicas.isEmpty ? "Sem registros" : currentPet.informacoes_medicas, icon: "doc.text.fill")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.03), radius: 8, y: 4)
                }
                .padding(.horizontal)
                
                // VACCINES HISTORY
                VStack(alignment: .leading, spacing: 14) {
                    Text("Vacinas Tomadas")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    if currentPet.vacinas.isEmpty {
                        HStack {
                            Spacer()
                            Text("Nenhuma vacina registrada.")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .italic()
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.03), radius: 8, y: 4)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(currentPet.vacinas) { vacina in
                                HStack {
                                    Image(systemName: "syringe.fill")
                                        .foregroundColor(.green)
                                        .frame(width: 32, height: 32)
                                        .background(Color.green.opacity(0.1))
                                        .clipShape(Circle())
                                    
                                    Text(vacina.nome)
                                        .font(.system(size: 15, weight: .bold))
                                    
                                    Spacer()
                                    
                                    Text(vacina.dataAplicacao.formatted(date: .numeric, time: .omitted))
                                        .font(.system(size: 13))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.black.opacity(0.03), radius: 8, y: 4)
                    }
                }
                .padding(.horizontal)
                
                // SERVICES HISTORY
                VStack(alignment: .leading, spacing: 14) {
                    Text("Histórico de Serviços")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 12) {
                        if let ultimo = ultimoServico {
                            DetailItemRow(title: "Último Serviço", value: ultimo, icon: "clock.fill")
                            
                            if !servicosRealizados.isEmpty {
                                Divider()
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Todos os Serviços Realizados")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.gray)
                                    
                                    ForEach(servicosRealizados, id: \.self) { servico in
                                        Label(servico, systemImage: "checkmark.circle.fill")
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.green)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        } else {
                            HStack {
                                Spacer()
                                Text("Nenhum serviço realizado ainda.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .italic()
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.03), radius: 8, y: 4)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Detalhes")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Editar") {
                    isShowingEditSheet = true
                }
            }
        }
        .sheet(isPresented: $isShowingEditSheet) {
            EdicaoPetDetailsSheet(pet: currentPet, tutorId: tutorId)
                .environmentObject(petViewModel)
                .environmentObject(tutorViewModel)
        }
        .background(
            LinearGradient(
                colors: [Color.blue.opacity(0.01), Color.white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// MARK: - DETAIL ITEM ROW COMPONENT
struct DetailItemRow: View {
    var title: String
    var value: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 32, height: 32)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

// MARK: - EDICAO PET DETAILS SHEET
struct EdicaoPetDetailsSheet: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petViewModel: PetViewModel
    @EnvironmentObject var tutorViewModel: TutorViewModel
    
    var pet: Pet
    var tutorId: String
    
    @State private var nome = ""
    @State private var raca = ""
    @State private var species: Species = .cachorro
    @State private var sexo = "Macho"
    @State private var dataNascimento = Date()
    @State private var informacoesMedicas = ""
    @State private var imagem = ""
    
    @State private var showSuccessAlert = false
    @State private var errorMessage: String? = nil
    @State private var isSaving = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Informações Básicas")) {
                    TextField("Nome do Pet", text: $nome)
                    
                    Picker("Espécie", selection: $species) {
                        ForEach(Species.allCases, id: \.self) { sp in
                            Text(sp.rawValue.capitalized).tag(sp)
                        }
                    }
                    
                    TextField("Raça", text: $raca)
                    
                    Picker("Sexo", selection: $sexo) {
                        Text("Macho").tag("Macho")
                        Text("Fêmea").tag("Fêmea")
                    }
                    .pickerStyle(.segmented)
                    
                    DatePicker("Data de Nascimento", selection: $dataNascimento, displayedComponents: .date)
                }
                
                Section(header: Text("Histórico Médico & Foto")) {
                    TextField("Informações Médicas", text: $informacoesMedicas)
                    TextField("URL da Imagem", text: $imagem)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.system(size: 14))
                    }
                }
            }
            .navigationTitle("Editar \(pet.nome)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        Task {
                            await saveChanges()
                        }
                    }
                    .fontWeight(.bold)
                    .disabled(nome.trimmingCharacters(in: .whitespaces).isEmpty || isSaving)
                }
            }
            .task {
                nome = pet.nome
                raca = pet.raca
                species = pet.species
                sexo = pet.sexo ?? "Macho"
                dataNascimento = pet.dataNascimento
                informacoesMedicas = pet.informacoes_medicas
                imagem = pet.imagem ?? ""
            }
            .alert("Alterações Salvas!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("As informações de \(nome) foram atualizadas.")
            }
        }
    }
    
    private func saveChanges() async {
        isSaving = true
        errorMessage = nil
        
        let updatedPet = Pet(
            id: pet.id,
            rev: pet.rev,
            nome: nome.trimmingCharacters(in: .whitespaces),
            species: species,
            raca: raca.trimmingCharacters(in: .whitespaces),
            dataNascimento: dataNascimento,
            vacinas: pet.vacinas,
            informacoes_medicas: informacoesMedicas.trimmingCharacters(in: .whitespaces),
            sexo: sexo,
            imagem: imagem.trimmingCharacters(in: .whitespaces).isEmpty ? nil : imagem,
            petshop: pet.petshop
        )
        
        await petViewModel.putPet(tutorId: tutorId, pet: updatedPet)
        isSaving = false
        
        if petViewModel.responseMessage.contains("Sucesso") {
            // Refresh tutor list / logged in tutor
            await tutorViewModel.getPerfilLogado(idDoTutorLogado: tutorId)
            await tutorViewModel.getTutores()
            showSuccessAlert = true
        } else {
            errorMessage = petViewModel.responseMessage
        }
    }
}
