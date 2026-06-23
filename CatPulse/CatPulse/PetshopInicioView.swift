import SwiftUI


struct PetshopInicioView: View {


    @StateObject var viewModel = PetshopViewModel()



    var body: some View {


        NavigationStack {


            ScrollView {


                VStack(spacing:25) {



                    // SALDO DO DIA

                    VStack(spacing:10) {


                        Text("Saldo do dia")
                            .font(.headline)
                            .foregroundColor(
                                .white.opacity(0.9)
                            )


                        Text("R$ 0,00")
                            .font(
                                .system(
                                    size:36,
                                    weight:.bold
                                )
                            )
                            .foregroundColor(
                                .white
                            )


                    }
                    .frame(
                        maxWidth:.infinity
                    )
                    .frame(
                        height:170
                    )
                    .background(
                        Color.blue
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius:30
                        )
                    )






                    // CADASTRAR NOVO PET

                    NavigationLink {


                        CadastroPetView()


                    } label: {


                        HStack {


                            Image(
                                systemName:"plus.circle.fill"
                            )


                            Text("Cadastrar novo pet")
                                .font(.headline)


                        }
                        .foregroundColor(
                            .white
                        )
                        .frame(
                            maxWidth:.infinity
                        )
                        .padding(.vertical,16)
                        .background(
                            Color.green
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:20
                            )
                        )


                    }









                    // CARDS DE QUANTIDADE

                    HStack(spacing:15) {



                        VStack(spacing:10) {


                            Text("Pets atendidos")
                                .font(.headline)
                                .foregroundColor(
                                    .white
                                )


                            Text(
                                "\(viewModel.petsEntregues.count)"
                            )
                            .font(
                                .system(
                                    size:35,
                                    weight:.bold
                                )
                            )
                            .foregroundColor(
                                .white
                            )


                        }
                        .frame(
                            maxWidth:.infinity
                        )
                        .frame(
                            height:140
                        )
                        .background(
                            Color.blue
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:25
                            )
                        )








                        VStack(spacing:10) {


                            Text("Restantes")
                                .font(.headline)
                                .foregroundColor(
                                    .white
                                )


                            Text(
                                "\(viewModel.petsPendentes.count)"
                            )
                            .font(
                                .system(
                                    size:35,
                                    weight:.bold
                                )
                            )
                            .foregroundColor(
                                .white
                            )


                        }
                        .frame(
                            maxWidth:.infinity
                        )
                        .frame(
                            height:140
                        )
                        .background(
                            Color.orange
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius:25
                            )
                        )



                    }









                    // AGUARDANDO ENTREGA

                    VStack(
                        alignment:.leading,
                        spacing:15
                    ) {



                        Text("Aguardando entrega")
                            .font(
                                .title2.bold()
                            )



                        ForEach(
                            viewModel.petsPendentes
                        ) { pet in



                            PetEntregaCardView(
                                pet:pet,
                                entregue:false
                            ) {


                                viewModel.entregar(
                                    pet
                                )


                            }



                        }



                    }









                    // ENTREGUES

                    VStack(
                        alignment:.leading,
                        spacing:15
                    ) {



                        Text("Entregues")
                            .font(
                                .title2.bold()
                            )
                            .padding(
                                .top
                            )



                        ForEach(
                            viewModel.petsEntregues
                        ) { pet in



                            PetEntregaCardView(
                                pet:pet,
                                entregue:true,
                                acao:{


                                },
                                desfazer:{


                                    viewModel.desfazerEntrega(
                                        pet
                                    )


                                }
                            )

                            .opacity(
                                0.45
                            )



                        }



                    }





                }
                .padding()




            }


            .navigationTitle(
                "Home"
            )


        }


    }


}



#Preview {

    PetshopInicioView()

}
