import SwiftUI


struct PetshopHomeView: View {
    var body: some View {
        TabView {
            PetshopInicioView()
                .tabItem {
                    Label(
                        "Home",
                        systemImage:"house.fill"
                    )
                }
            FilaView()
                .tabItem {
                    Label(
                        "Fila",
                        systemImage:"list.bullet"
                    )
                }
            LojaPetshopView()
                .tabItem {
                    Label(
                        "Loja",
                        systemImage:"cart.fill"
                    )
                }
            ListaPetsPetshopView()
                .tabItem {
                    Label(
                        "Pets",
                        systemImage:"dog.fill"
                    )
                }
        }

    }
}
#Preview {
    PetshopHomeView()
}
