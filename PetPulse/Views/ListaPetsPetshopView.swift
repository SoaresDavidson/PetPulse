import SwiftUI

struct ListaPetsPetshopView: View {
    @EnvironmentObject var tutorViewModel: TutorViewModel
    @EnvironmentObject var petViewModel: PetViewModel
    
    @State private var petToEdit: Pet? = nil
    @State private var petToDelete: Pet? = nil
    @State private var showDeleteConfirmation = false
    @State private var isDeleting = false
    
    private var todosOsPets: [Pet] {
        tutorViewModel.tutores.compactMap { $0.pets }.flatMap { $0 }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if todosOsPets.isEmpty {
                    Section {
                        HStack {
                            Spacer()
                            Text("Nenhum pet cadastrado no momento.")
                                .foregroundColor(.gray)
                                .italic()
                            Spacer()
                        }
                        .padding()
                    }
                } else {
                    ForEach(todosOsPets) { pet in
                        PetRow(
                            pet: pet,
                            onEdit: {
                                petToEdit = pet
                            },
                            onDelete: {
                                petToDelete = pet
                                showDeleteConfirmation = true
                            }
                        )
                    }
                }
            }
            .navigationTitle("Lista de Pets")
            .refreshable {
                await tutorViewModel.getTutores()
            }
            .task {
                if tutorViewModel.tutores.isEmpty {
                    await tutorViewModel.getTutores()
                }
            }
            .sheet(item: $petToEdit) { pet in
                EdicaoPetSheet(pet: pet, tutorId: findTutorId(for: pet))
                    .environmentObject(petViewModel)
                    .environmentObject(tutorViewModel)
            }
            .alert("Deletar Pet", isPresented: $showDeleteConfirmation, presenting: petToDelete) { pet in
                Button("Deletar", role: .destructive) {
                    Task {
                        await confirmDelete(pet: pet)
                    }
                }
                Button("Cancelar", role: .cancel) {}
            } message: { pet in
                Text("Tem certeza que deseja deletar \(pet.nome)? Esta ação não pode ser desfeita.")
            }
            .overlay {
                if isDeleting {
                    ProgressView("Deletando pet...")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
            }
        }
    }
    
    private func findTutorId(for pet: Pet) -> String {
        if let tutor = tutorViewModel.tutores.first(where: { $0.pets?.contains(where: { $0.id == pet.id }) == true }) {
            return tutor.id ?? "tutor_1782166739059"
        }
        return "tutor_1782166739059"
    }
    
    private func confirmDelete(pet: Pet) async {
        guard let petId = pet.id else { return }
        isDeleting = true
        let tutorId = findTutorId(for: pet)
        
        await petViewModel.deletePet(tutorId: tutorId, id: String(petId))
        await tutorViewModel.getTutores()
        
        isDeleting = false
        petToDelete = nil
    }
}

// MARK: - PET ROW COMPONENT
struct PetRow: View {
    var pet: Pet
    var onEdit: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            if let imageString = pet.imagem,
               !imageString.isEmpty {
                Image(imageString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.nome)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 8) {
                    Text(pet.species.rawValue.capitalized)
                        .font(.system(size: 13, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(6)
                    
                    Text(pet.raca)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            if let sexo = pet.sexo {
                Image(systemName: sexo == "Macho" ? "male" : "female")
                    .foregroundColor(sexo == "Macho" ? .blue : .pink)
                    .font(.system(size: 16, weight: .bold))
            }
            
            HStack(spacing: 10) {
                Button(action: onEdit) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                        .padding(8)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.borderless)
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - EDICAO PET SHEET
struct EdicaoPetSheet: View {
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
            await tutorViewModel.getTutores()
            showSuccessAlert = true
        } else {
            errorMessage = petViewModel.responseMessage
        }
    }
}
