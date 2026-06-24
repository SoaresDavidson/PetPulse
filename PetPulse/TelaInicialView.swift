import SwiftUI

struct TelaInicialView: View {
    @EnvironmentObject var tutorViewModel: TutorViewModel
    @EnvironmentObject var petshopViewModel: PetshopViewModel
    
    @State private var selectedTutorId: String = ""
    @State private var selectedPetshopId: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 36) {
                    
                    Spacer()
                        .frame(height: 20)
                    
                    // HEADER
                    VStack(spacing: 8) {
                        Text("PetPulse")
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(.blue)
                        
                        Text("Selecione sua conta para entrar")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(spacing: 28) {
                        
                        // CLIENT (TUTOR) LOGIN SECTION
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                                Text("Área do Cliente")
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }
                            
                            if tutorViewModel.tutores.isEmpty {
                                ProgressView("Buscando clientes...")
                                    .padding(.vertical, 8)
                            } else {
                                Picker("Cliente", selection: $selectedTutorId) {
                                    Text("Selecione um cliente").tag("")
                                    ForEach(tutorViewModel.tutores) { tutor in
                                        Text(tutor.nome).tag(tutor.id ?? "")
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.blue.opacity(0.06))
                                .cornerRadius(12)
                            }
                            
                            NavigationLink {
                                ClienteHomeView()
                                    .task {
                                        await tutorViewModel.getPerfilLogado(idDoTutorLogado: selectedTutorId)
                                    }
                            } label: {
                                Text("Entrar como Cliente")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(selectedTutorId.isEmpty ? Color.gray : Color.blue)
                                    .cornerRadius(16)
                            }
                            .disabled(selectedTutorId.isEmpty)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.04), radius: 10, y: 5)
                        
                        // PETSHOP LOGIN SECTION
                        VStack(spacing: 16) {
                            HStack {
                                Image(systemName: "shop.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                Text("Área do Petshop")
                                    .font(.system(size: 18, weight: .bold))
                                Spacer()
                            }
                            
                            if petshopViewModel.petshops.isEmpty {
                                ProgressView("Buscando petshops...")
                                    .padding(.vertical, 8)
                            } else {
                                Picker("Petshop", selection: $selectedPetshopId) {
                                    Text("Selecione um petshop").tag("")
                                    ForEach(petshopViewModel.petshops) { shop in
                                        Text(shop.nome).tag(shop.id ?? "")
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.orange.opacity(0.06))
                                .cornerRadius(12)
                            }
                            
                            NavigationLink {
                                PetshopHomeView()
                                    .task {
                                        if let shop = petshopViewModel.petshops.first(where: { $0.id == selectedPetshopId }) {
                                            petshopViewModel.petshopLogado = shop
                                        }
                                    }
                            } label: {
                                Text("Entrar como Petshop")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(selectedPetshopId.isEmpty ? Color.gray : Color.orange)
                                    .cornerRadius(16)
                            }
                            .disabled(selectedPetshopId.isEmpty)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(24)
                        .shadow(color: Color.black.opacity(0.04), radius: 10, y: 5)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.02), Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .task {
                await tutorViewModel.getTutores()
                await petshopViewModel.getPetshops()
                
                // Select first items as default when loaded
                if selectedTutorId.isEmpty, let firstTutor = tutorViewModel.tutores.first {
                    selectedTutorId = firstTutor.id ?? ""
                }
                if selectedPetshopId.isEmpty, let firstShop = petshopViewModel.petshops.first {
                    selectedPetshopId = firstShop.id ?? ""
                }
            }
            .onChange(of: tutorViewModel.tutores.count) { _, _ in
                if selectedTutorId.isEmpty, let firstTutor = tutorViewModel.tutores.first {
                    selectedTutorId = firstTutor.id ?? ""
                }
            }
            .onChange(of: petshopViewModel.petshops.count) { _, _ in
                if selectedPetshopId.isEmpty, let firstShop = petshopViewModel.petshops.first {
                    selectedPetshopId = firstShop.id ?? ""
                }
            }
        }
    }
}

#Preview {
    TelaInicialView()
        .environmentObject(TutorViewModel())
        .environmentObject(PetshopViewModel())
}
