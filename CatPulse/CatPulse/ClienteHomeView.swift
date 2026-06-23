import SwiftUI



struct ClienteHomeView: View {



    @StateObject var viewModel = PetViewModel()




    var body: some View {



        TabView {



            NavigationStack {



                ScrollView {



                    VStack(
                        spacing:25
                    ) {



                        ForEach(
                            viewModel.pets
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


        .onAppear {


            viewModel.carregarPetsDoBanco()


        }


    }

}




#Preview {

    ClienteHomeView()

}
