import SwiftUI

struct CadastroPetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var petViewModel: PetViewModel
    @EnvironmentObject var tutorViewModel: TutorViewModel
    @EnvironmentObject var petshopViewModel: PetshopViewModel
    
    var tutorId: String? = nil
    
    @State private var selectedTutorId: String = ""
    @State private var nome = ""
    @State private var raca = ""
    @State private var species: Species = .cachorro
    @State private var sexo = "Macho"
    @State private var dataNascimento = Date()
    @State private var informacoesMedicas = ""
    @State private var imagem = ""
    
    @State private var showSuccessAlert = false
    @State private var errorMessage: String? = nil
    @State private var isSubmitting = false
    
    var body: some View {
        Form {
            // TUTOR (DONO) SELECTION (Only if not provided)
            if tutorId == nil {
                Section(header: Text("Tutor / Dono")) {
                    if tutorViewModel.tutores.isEmpty {
                        Text("Nenhum tutor encontrado.")
                            .foregroundColor(.gray)
                    } else {
                        Picker("Selecione o Tutor", selection: $selectedTutorId) {
                            Text("Selecione um tutor").tag("")
                            ForEach(tutorViewModel.tutores) { tutor in
                                Text(tutor.nome).tag(tutor.id ?? "")
                            }
                        }
                    }
                }
            }
            
            // BASIC PET INFORMATION
            Section(header: Text("Informações do Pet")) {
                TextField("Nome do Pet", text: $nome)
                    .autocorrectionDisabled()
                
                Picker("Espécie", selection: $species) {
                    ForEach(Species.allCases, id: \.self) { sp in
                        Text(sp.rawValue.capitalized).tag(sp)
                    }
                }
                
                TextField("Raça", text: $raca)
                    .autocorrectionDisabled()
                
                Picker("Sexo", selection: $sexo) {
                    Text("Macho").tag("Macho")
                    Text("Fêmea").tag("Fêmea")
                }
                .pickerStyle(.segmented)
                
                DatePicker("Data de Nascimento", selection: $dataNascimento, displayedComponents: .date)
            }
            
            // MEDICAL INFO & IMAGE
            Section(header: Text("Ficha Médica & Foto")) {
                TextField("Informações Médicas (ex: Alergias)", text: $informacoesMedicas)
                    .autocorrectionDisabled()
                
                TextField("URL da Imagem (opcional)", text: $imagem)
                    .keyboardType(.URL)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.none)
            }
            
            // SUBMIT BUTTON
            Section {
                Button {
                    Task {
                        await registerPet()
                    }
                } label: {
                    HStack {
                        Spacer()
                        if isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Cadastrar Pet")
                                .fontWeight(.bold)
                        }
                        Spacer()
                    }
                }
                .foregroundColor(.white)
                .listRowBackground(canSubmit ? Color.green : Color.gray)
                .disabled(!canSubmit || isSubmitting)
            }
            
            if let error = errorMessage {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.system(size: 14, weight: .medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("Novo Pet")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            // Fetch tutores if empty and we need to choose one
            if tutorId == nil && tutorViewModel.tutores.isEmpty {
                await tutorViewModel.getTutores()
            }
            
            // Set initial tutor selection
            if let tutorId = tutorId {
                selectedTutorId = tutorId
            } else if let firstTutor = tutorViewModel.tutores.first {
                selectedTutorId = firstTutor.id ?? ""
            }
        }
    }
    
    private var canSubmit: Bool {
        !selectedTutorId.isEmpty &&
        !nome.trimmingCharacters(in: .whitespaces).isEmpty &&
        !raca.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func registerPet() async {
        guard canSubmit else { return }
        
        isSubmitting = true
        errorMessage = nil
        
        let newPet = Pet(
            id: nil,
            rev: nil,
            nome: nome.trimmingCharacters(in: .whitespaces),
            species: species,
            raca: raca.trimmingCharacters(in: .whitespaces),
            dataNascimento: dataNascimento,
            vacinas: [],
            informacoes_medicas: informacoesMedicas.trimmingCharacters(in: .whitespaces),
            sexo: sexo,
            imagem: imagem.trimmingCharacters(in: .whitespaces).isEmpty ? nil : imagem,
            petshop: petshopViewModel.petshopLogado?.nome
        )
        
        await petViewModel.postPet(tutorId: selectedTutorId, pet: newPet)
        
        isSubmitting = false
        
        if petViewModel.responseMessage.contains("Sucesso") {
            // Reload tutores so the main screen gets the updated pet list
            await tutorViewModel.getTutores()
            dismiss()
        } else {
            errorMessage = petViewModel.responseMessage
        }
    }
}

#Preview {
    NavigationStack {
        CadastroPetView()
            .environmentObject(PetViewModel())
            .environmentObject(TutorViewModel())
            .environmentObject(PetshopViewModel())
    }
}
