import SwiftUI

struct TelaInicialView: View {
    @EnvironmentObject var tutorViewModel: TutorViewModel
    private var tutor: Tutor?
    var id = "tutor_1782166739059"

    var body: some View {

        NavigationStack {

            VStack(spacing:40) {

                Spacer()

                Text("CatPulse")
                    .font(
                        .largeTitle.bold()
                    )

                Text("Escolha uma opção")
                    .font(
                        .title3
                    )
                    .foregroundColor(.gray)

                VStack(spacing:20) {

                    NavigationLink {
                        // Passa o tutor atual do view model como opcional
                        ClienteHomeView(tutor: tutorViewModel.tutorLogado)
                            .task {
                                await tutorViewModel.getPerfilLogado(idDoTutorLogado: id)
                            }
                    } label: {
                        Text("Cliente")
                            .font(
                                .title2.bold()
                            )
                            .foregroundColor(.white)
                            .frame(
                                maxWidth:.infinity
                            )
                            .padding()
                            .background(
                                Color.blue
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius:20
                                )
                            )
                    }

                    NavigationLink {
                        // PetshopHomeView()
                    } label: {
                        Text("Petshop")
                            .font(
                                .title2.bold()
                            )
                            .foregroundColor(.white)
                            .frame(
                                maxWidth:.infinity
                            )
                            .padding()
                            .background(
                                Color.orange
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius:20
                                )
                            )
                    }

                }
                .padding(.horizontal,40)

                Spacer()

            }
            .navigationTitle("")
            .navigationBarHidden(true)

        }

    }

}

#Preview {
    TelaInicialView()
        .environmentObject(TutorViewModel())
}
