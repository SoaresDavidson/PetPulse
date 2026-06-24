import SwiftUI

struct PerfilView: View {
    @EnvironmentObject var tutorViewModel: TutorViewModel
    
    @State private var isEditing = false
    @State private var nome = ""
    @State private var telefone = ""
    @State private var endereco = ""
    @State private var isSaving = false
    @State private var successMessage: String? = nil
    @State private var errorMessage: String? = nil
    
    private var tutor: Tutor? {
        tutorViewModel.tutorLogado
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    if let tutor = tutor {
                        // HEADER WITH AVATAR
                        VStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 90, height: 90)
                                    .shadow(color: Color.blue.opacity(0.3), radius: 10, y: 5)
                                
                                Text(getInitials(tutor.nome))
                                    .font(.system(size: 32, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(spacing: 4) {
                                Text(tutor.nome)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.primary)
                                
                                Text(tutor.email)
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.top, 24)
                        
                        // STATS ROW (e.g. Pets count)
                        HStack(spacing: 20) {
                            VStack(spacing: 6) {
                                Text("\(tutor.pets?.count ?? 0)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.blue)
                                Text("Pets Cadastrados")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue.opacity(0.08))
                            .cornerRadius(16)
                            
                            VStack(spacing: 6) {
                                Text("\(tutor.notificacoes?.count ?? 0)")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.orange)
                                Text("Notificações")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.orange.opacity(0.08))
                            .cornerRadius(16)
                        }
                        .padding(.horizontal)
                        
                        // DETAILS OR EDIT FORM
                        if isEditing {
                            VStack(spacing: 16) {
                                Text("Editar Informações")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Nome")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                    TextField("Nome", text: $nome)
                                        .textFieldStyle(.roundedBorder)
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Telefone")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                    TextField("Telefone", text: $telefone)
                                        .textFieldStyle(.roundedBorder)
                                        .keyboardType(.phonePad)
                                }
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Endereço")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                    TextField("Endereço", text: $endereco)
                                        .textFieldStyle(.roundedBorder)
                                }
                                
                                if let error = errorMessage {
                                    Text(error)
                                        .font(.system(size: 12))
                                        .foregroundColor(.red)
                                }
                                
                                HStack(spacing: 12) {
                                    Button("Cancelar") {
                                        isEditing = false
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.gray.opacity(0.15))
                                    .foregroundColor(.primary)
                                    .cornerRadius(10)
                                    
                                    Button {
                                        Task {
                                            await saveChanges()
                                        }
                                    } label: {
                                        HStack {
                                            if isSaving {
                                                ProgressView()
                                                    .tint(.white)
                                            } else {
                                                Text("Salvar")
                                                    .fontWeight(.semibold)
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .disabled(isSaving)
                                }
                                .padding(.top, 8)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, y: 4)
                            .padding(.horizontal)
                        } else {
                            // INFO DISPLAY CARD
                            VStack(spacing: 16) {
                                InfoRow(icon: "doc.text.fill", title: "CPF", value: formatCPF(tutor.cpf))
                                Divider()
                                InfoRow(icon: "phone.fill", title: "Telefone", value: tutor.telefone)
                                Divider()
                                InfoRow(icon: "mappin.and.ellipse", title: "Endereço", value: tutor.endereco)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.04), radius: 8, y: 4)
                            .padding(.horizontal)
                            
                            // EDIT PROFILE BUTTON
                            Button {
                                startEditing()
                            } label: {
                                Text("Editar Perfil")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(Color.blue)
                                    .cornerRadius(25)
                                    .shadow(color: Color.blue.opacity(0.2), radius: 8, y: 4)
                            }
                            .padding(.horizontal)
                        }
                        
                        if let success = successMessage {
                            Text(success)
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.green)
                                .padding(.top, 4)
                        }
                        
                    } else {
                        // FALLBACK / EMPTY STATE
                        VStack(spacing: 16) {
                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            Text("Perfil não carregado.")
                                .foregroundColor(.gray)
                            Button("Tentar Novamente") {
                                Task {
                                    await tutorViewModel.getPerfilLogado(idDoTutorLogado: "tutor_1782166739059")
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.top, 100)
                    }
                }
            }
            .navigationTitle("Meu Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.02), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .task {
                if tutorViewModel.tutorLogado == nil {
                    await tutorViewModel.getPerfilLogado(idDoTutorLogado: "tutor_1782166739059")
                }
            }
        }
    }
    
    private func getInitials(_ name: String) -> String {
        let components = name.split(separator: " ")
        if components.count >= 2 {
            return "\(components[0].prefix(1))\(components[1].prefix(1))".uppercased()
        } else if let first = components.first {
            return String(first.prefix(2)).uppercased()
        }
        return "T"
    }
    
    private func formatCPF(_ cpf: String) -> String {
        let clean = cpf.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard clean.count == 11 else { return cpf }
        let index3 = clean.index(clean.startIndex, offsetBy: 3)
        let index6 = clean.index(clean.startIndex, offsetBy: 6)
        let index9 = clean.index(clean.startIndex, offsetBy: 9)
        
        return "\(clean[..<index3]).\(clean[index3..<index6]).\(clean[index6..<index9])-\(clean[index9...])"
    }
    
    private func startEditing() {
        if let tutor = tutor {
            nome = tutor.nome
            telefone = tutor.telefone
            endereco = tutor.endereco
            isEditing = true
            errorMessage = nil
            successMessage = nil
        }
    }
    
    private func saveChanges() async {
        guard let currentTutor = tutor else { return }
        
        if nome.trimmingCharacters(in: .whitespaces).isEmpty {
            errorMessage = "O nome não pode estar vazio."
            return
        }
        
        isSaving = true
        errorMessage = nil
        successMessage = nil
        
        var updatedTutor = currentTutor
        updatedTutor.nome = nome
        updatedTutor.telefone = telefone
        updatedTutor.endereco = endereco
        
        await tutorViewModel.putTutor(tutor: updatedTutor)
        
        isSaving = false
        
        if tutorViewModel.responseMessage.contains("Sucesso") {
            successMessage = "Perfil atualizado com sucesso!"
            isEditing = false
            // Refresh
            if let tutorId = currentTutor.id {
                await tutorViewModel.getPerfilLogado(idDoTutorLogado: tutorId)
            }
        } else {
            errorMessage = tutorViewModel.responseMessage
        }
    }
}

// MARK: - INFO ROW COMPONENT
struct InfoRow: View {
    var icon: String
    var title: String
    var value: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
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
