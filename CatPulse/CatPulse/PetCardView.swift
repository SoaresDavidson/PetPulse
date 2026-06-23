import SwiftUI


struct PetCardView: View {


    var pet: Pet



    var body: some View {


        VStack(spacing: 0) {



            // STATUS NO CANTO SUPERIOR DIREITO

            HStack {


                Spacer()



                if let status = pet.status {


                    Text(status)
                        .font(
                            .system(
                                size: 11,
                                weight: .semibold
                            )
                        )
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Color.green.opacity(0.2)
                        )
                        .clipShape(
                            Capsule()
                        )


                }


            }
            .padding(.top, 14)
            .padding(.horizontal, 22)







            // FOTO + INFORMAÇÕES (corrigir saporra depois)


            HStack(spacing: 16) {



                if let imagem = pet.imagem,
                   !imagem.isEmpty {


                    AsyncImage(
                        url: URL(string: imagem)
                    ) { image in


                        image
                            .resizable()
                            .scaledToFill()


                    } placeholder: {


                        ProgressView()


                    }
                    .frame(
                        width: 90,
                        height: 90
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 25
                        )
                    )



                } else {



                    RoundedRectangle(
                        cornerRadius: 25
                    )
                    .fill(
                        Color.gray.opacity(0.15)
                    )
                    .frame(
                        width: 90,
                        height: 90
                    )


                }




                VStack(
                    alignment: .leading,
                    spacing: 7
                ) {



                    Text(
                        pet.nome ?? ""
                    )
                    .font(
                        .system(
                            size: 24,
                            weight: .bold
                        )
                    )
                    .foregroundColor(
                        .blue
                    )





                    if let raca = pet.raca {



                        Label(
                            raca,
                            systemImage: "pawprint.fill"
                        )
                        .font(
                            .system(size: 14)
                        )


                    }







                    if let servicos = pet.servicos {



                        HStack(spacing: 5) {



                            ForEach(
                                servicos.prefix(2),
                                id: \.self
                            ) { servico in



                                Text(servico)
                                    .font(
                                        .system(size: 11)
                                    )
                                    .padding(.horizontal,8)
                                    .padding(.vertical,5)
                                    .background(
                                        Color.blue.opacity(0.15)
                                    )
                                    .clipShape(
                                        Capsule()
                                    )


                            }


                        }


                    }



                }



                Spacer()



            }
            .padding(.horizontal,22)
            .padding(.top,2)
            .padding(.bottom,6)









            Divider()
                .padding(.horizontal,22)
                .padding(.vertical,6)








            // DATA DO ÚLTIMO SERVIÇO


            HStack {


                Text(
                    pet.ultimoServico != nil ?
                    "Último serviço: \(pet.ultimoServico!)"
                    :
                    ""
                )
                .font(
                    .system(size:14)
                )
                .italic()



                Spacer()



            }
            .frame(height:32)
            .padding(.horizontal,22)









            // BOTÕES


            HStack(spacing:12) {



                NavigationLink {


                    PetDetalhesView(
                        pet: pet
                    )


                } label: {


                    Text("Detalhes")
                        .font(
                            .system(
                                size:15,
                                weight:.semibold
                            )
                        )
                        .foregroundColor(.white)
                        .frame(
                            maxWidth:.infinity
                        )
                        .padding(.vertical,10)
                        .background(
                            Color.blue
                        )
                        .clipShape(
                            Capsule()
                        )


                }




                NavigationLink {


                    AgendarView(
                        pet:pet
                    )


                } label: {


                    Text("Agendar")
                        .font(
                            .system(
                                size:15,
                                weight:.semibold
                            )
                        )
                        .foregroundColor(.black)
                        .frame(
                            maxWidth:.infinity
                        )
                        .padding(.vertical,10)
                        .background(
                            Color.orange
                        )
                        .clipShape(
                            Capsule()
                        )


                }



            }
            .padding(.horizontal,22)
            .padding(.bottom,12)





        }




        .frame(
            width: UIScreen.main.bounds.width * 0.82,
            height:230
        )



        .background(
            Color.white
        )



        .clipShape(
            RoundedRectangle(
                cornerRadius:32
            )
        )



        .shadow(
            color:Color.black.opacity(0.08),
            radius:10,
            y:5
        )


    }

}
