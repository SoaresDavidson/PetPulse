import SwiftUI

struct ClienteHomeView: View {

    @StateObject var petViewModel = PetViewModel()

    var body: some View {

        TabView {

            NavigationStack {

                ScrollView {

                    VStack(
                        spacing:25
                    ) {

                        ForEach(
                            petViewModel.pets
                        ) { pet in

                            PetCardView(
                                pet: pet
                            )

                        }

                    }
                    .padding(.top)

                }

                .navigationTitle(
                    "Meus Pets"
                )

            }

            .tabItem {

                Label(
                    "Home",
                    systemImage:"pawprint.fill"
                )

            }

            Text("Loja")
                .tabItem {

                    Label(
                        "Loja",
                        systemImage:"cart.fill"
                    )

                }

            Text("Notificações")
                .tabItem {

                    Label(
                        "Notificações",
                        systemImage:"bell.fill"
                    )

                }

        }

        .task {
            _ = await petViewModel.getPets()
        }

    }

}

#Preview {

    ClienteHomeView()

}
