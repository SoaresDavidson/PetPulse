import SwiftUI

struct ClienteHomeView: View {
    @EnvironmentObject var tutorViewModel: TutorViewModel
    // Se quiser permitir injeção direta de pets, mantenha este fallback
    var pets: [Pet] = []

    // Lista efetiva exibida: prioriza os pets do tutor, senão usa o fallback
    private var petsDoTutor: [Pet] {
        if let tutor = tutorViewModel.tutorLogado {
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
                        if petsDoTutor.isEmpty {
                            Text("Você ainda não cadastrou pets.")
                                .foregroundColor(.gray)
                                .padding(.top, 16)
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle(tutorViewModel.tutorLogado?.nome ?? "Meus Pets")
            }
            .tabItem {
                Label("Home", systemImage:"pawprint.fill")
            }


            NotificacoesView()
                .tabItem {
                    Label("Notificações", systemImage:"bell.fill")
                }

            PerfilView()
                .tabItem {
                    Label("Perfil", systemImage:"person.fill")
                }
        }
    }
}

#Preview {
    ClienteHomeView()
        .environmentObject(TutorViewModel())
}
