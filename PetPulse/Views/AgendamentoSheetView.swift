import SwiftUI

struct AgendamentoSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petshopViewModel: PetshopViewModel
    @EnvironmentObject var agendamentoViewModel: AgendamentoViewModel
    @EnvironmentObject var tutorViewModel: TutorViewModel
    
    var pet: Pet
    
    @State private var selectedPetshopId: String? = nil
    @State private var selectedService: Service? = nil
    @State private var selectedDate: Date? = nil
    @State private var selectedTime: String? = nil
    @State private var mostrarHorarios: Bool = false
    @State private var showSuccessAlert = false
    @State private var errorMessage: String? = nil
    @State private var isSubmitting = false
    
    let timeSlots = ["09:00", "10:00", "11:00", "14:00", "15:00", "16:00", "17:00"]
    
    private var selectedPetshop: Petshop? {
        petshopViewModel.petshops.first(where: { $0.id == selectedPetshopId })
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // HEADER
                    VStack(spacing: 8) {
                        Text("Agendamento")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text("Para \(pet.nome)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 16)
                    
                    // SELECT PETSHOP
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Selecione o Petshop")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                        
                        if petshopViewModel.petshops.isEmpty {
                            HStack {
                                Spacer()
                                ProgressView("Carregando petshops...")
                                Spacer()
                            }
                            .padding()
                        } else {
                            Picker("Petshop", selection: $selectedPetshopId) {
                                Text("Selecione um petshop").tag(nil as String?)
                                ForEach(petshopViewModel.petshops) { shop in
                                    Text(shop.nome).tag(shop.id)
                                }
                            }
                            .pickerStyle(.menu)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.blue.opacity(0.08))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // SERVICES LIST FOR SELECTED PETSHOP
                    if let shop = selectedPetshop {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Serviços Disponíveis")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            
                            if shop.servicos.isEmpty {
                                Text("Nenhum serviço disponível para este petshop.")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                                    .padding(.horizontal)
                            } else {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 14) {
                                        ForEach(shop.servicos) { service in
                                            ServiceCard(
                                                service: service,
                                                isSelected: selectedService?.id == service.id
                                            )
                                            .onTapGesture {
                                                selectedService = service
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                    // CALENDAR SELECTION
                    if selectedService != nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Selecione a Data")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.horizontal)
                            
                            CalendarioView(
                                diaSelecionado: $selectedDate,
                                mostrarHorarios: $mostrarHorarios
                            )
                            .padding(.horizontal, 10)
                            .padding(.vertical, 16)
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
                        }
                    }
                    
                    // TIME SLOTS SELECTION
                    if let selectedDate = selectedDate {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Horários Disponíveis para \(selectedDate.formatted(date: .abbreviated, time: .omitted))")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.primary)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 4), spacing: 10) {
                                ForEach(timeSlots, id: \.self) { slot in
                                    Text(slot)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(selectedTime == slot ? .white : .primary)
                                        .padding(.vertical, 10)
                                        .frame(maxWidth: .infinity)
                                        .background(selectedTime == slot ? Color.blue : Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            selectedTime = slot
                                        }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // ERROR MESSAGE
                    if let error = errorMessage {
                        Text(error)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    // BOOK BUTTON
                    Button {
                        Task {
                            await confirmScheduling()
                        }
                    } label: {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Text("Confirmar Agendamento")
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(canSubmit ? Color.green : Color.gray)
                        .cornerRadius(25)
                        .shadow(color: canSubmit ? Color.green.opacity(0.3) : Color.clear, radius: 10, y: 5)
                    }
                    .disabled(!canSubmit || isSubmitting)
                    .padding(.horizontal)
                    .padding(.bottom, 24)
                }
            }
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.03), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .task {
                await petshopViewModel.getPetshops()
                if selectedPetshopId == nil, let firstShop = petshopViewModel.petshops.first {
                    selectedPetshopId = firstShop.id
                }
            }
            .alert("Agendamento Confirmado!", isPresented: $showSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("O serviço para \(pet.nome) foi agendado com sucesso.")
            }
        }
    }
    
    private var canSubmit: Bool {
        selectedPetshopId != nil &&
        selectedService != nil &&
        selectedDate != nil &&
        selectedTime != nil
    }
    
    private func confirmScheduling() async {
        guard let petshopIdStr = selectedPetshopId,
              let service = selectedService,
              let date = selectedDate,
              let timeStr = selectedTime,
              let petId = pet.id else {
            errorMessage = "Preencha todos os campos."
            return
        }
        
        isSubmitting = true
        errorMessage = nil
        
        // Parse time slot
        let components = timeStr.split(separator: ":")
        guard components.count == 2,
              let hour = Int(components[0]),
              let minute = Int(components[1]) else {
            errorMessage = "Horário inválido."
            isSubmitting = false
            return
        }
        
        // Combine date and time
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        
        guard let finalDate = calendar.date(from: dateComponents) else {
            errorMessage = "Data inválida."
            isSubmitting = false
            return
        }
        
        let tutorId = tutorViewModel.tutorLogado?.id ?? "tutor_1782166739059"
        
        let scheduling = Scheduling(
            id: nil,
            rev: nil,
            tutorId: tutorId,
            petId: petId,
            petshopId: petshopIdStr,
            serviceId: service.id ?? 1,
            dataHoraAgendamento: finalDate,
            statusServico: .esperando
        )
        
        await agendamentoViewModel.postAgendamento(agendamento: scheduling)
        
        isSubmitting = false
        
        if agendamentoViewModel.responseMessage.contains("Sucesso") {
            // Refresh list
            await agendamentoViewModel.getAgendamentos()
            showSuccessAlert = true
        } else {
            errorMessage = agendamentoViewModel.responseMessage
        }
    }
}

// MARK: - SERVICE CARD COMPONENT
struct ServiceCard: View {
    var service: Service
    var isSelected: Bool
    
    private var serviceIcon: String {
        let name = service.nomeServico.lowercased()
        if name.contains("banho") {
            return "drop.fill"
        } else if name.contains("tosa") {
            return "scissors"
        } else if name.contains("consulta") || name.contains("médico") {
            return "stethoscope"
        } else if name.contains("vacina") {
            return "syringe"
        } else {
            return "sparkles"
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: serviceIcon)
                .font(.system(size: 24))
                .foregroundColor(isSelected ? .white : .blue)
                .frame(width: 50, height: 50)
                .background(isSelected ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(spacing: 4) {
                Text(service.nomeServico)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(isSelected ? .white : .primary)
                    .lineLimit(1)
                
                Text("\(service.duracaoEstimada) min")
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
                
                Text(String(format: "R$ %.2f", service.preco))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .blue)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 14)
        .frame(width: 130)
        .background(isSelected ? Color.blue : Color.white)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.15), lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(isSelected ? 0.15 : 0.03), radius: 6, y: 3)
    }
}
