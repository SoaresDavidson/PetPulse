import SwiftUI

struct ClienteHomeView: View {
    var tutor: Tutor?
    // Se quiser permitir injeção direta de pets, mantenha este fallback
    var pets: [Pet] = []

    // Lista efetiva exibida: prioriza os pets do tutor, senão usa o fallback
    private var petsDoTutor: [Pet] {
        if let tutor = tutor {
            // Ajuste "tutor.pets" para o nome correto no seu modelo Tutor
            return tutor.pets ?? []
        }
        return pets
    }

    var body: some View {

        TabView {
            NavigationStack {
                ScrollView {
                    VStack(spacing: 25) {
                        ForEach(petsDoTutor) { pet in
                            PetCardView(pet: pet)
                        }
                        // Caso não haja pets, exibe uma mensagem amigável
                        if petsDoTutor.isEmpty {
                            Text("Você ainda não cadastrou pets.")
                                .foregroundColor(.gray)
                                .padding(.top, 16)
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle("Meus Pets")
            }
            .tabItem {
                Label("Home", systemImage:"pawprint.fill")
            }

            Text("Loja")
                .tabItem {
                    Label("Loja", systemImage:"cart.fill")
                }

            Text("Notificações")
                .tabItem {
                    Label("Notificações", systemImage:"bell.fill")
                }
        }
    }
}

#Preview {
    // Exemplo de preview com tutor nulo e lista vazia (ajuste conforme necessário)
    ClienteHomeView()
}
