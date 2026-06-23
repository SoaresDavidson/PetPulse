import SwiftUI

struct PetDetalhesView: View {

    var pet: Pet


    var body: some View {

        ScrollView {

            VStack(spacing: 25) {


                // IMAGEM

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
                        width: 160,
                        height: 160
                    )
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 35
                        )
                    )


                } else {


                    RoundedRectangle(
                        cornerRadius:35
                    )
                    .fill(
                        Color.gray.opacity(0.15)
                    )
                    .frame(
                        width:160,
                        height:160
                    )


                }



                // NOME

                Text(
                    pet.nome ?? "Sem nome"
                )
                .font(
                    .largeTitle.bold()
                )
                .foregroundColor(.blue)



                // RAÇA

                if let raca = pet.raca {

                    Label(
                        raca,
                        systemImage:"pawprint.fill"
                    )
                    .font(.title3)

                }



                Divider()



                // STATUS

                if let status = pet.status {

                    VStack {

                        Text("Status")
                            .font(.headline)


                        Text(status)
                            .padding()
                            .frame(
                                maxWidth:.infinity
                            )
                            .background(
                                Color.green.opacity(0.2)
                            )
                            .clipShape(
                                Capsule()
                            )

                    }

                }



                // SERVIÇOS

                if let servicos = pet.servicos {


                    VStack(alignment:.leading, spacing:10) {


                        Text("Serviços realizados")
                            .font(.headline)



                        ForEach(
                            servicos,
                            id:\.self
                        ) { servico in


                            Label(
                                servico,
                                systemImage:"checkmark.circle.fill"
                            )


                        }


                    }
                    .frame(
                        maxWidth:.infinity,
                        alignment:.leading
                    )


                }



                // ÚLTIMO SERVIÇO


                if let ultimo = pet.ultimoServico {


                    VStack(alignment:.leading) {


                        Text("Último serviço")
                            .font(.headline)



                        Text(ultimo)


                    }
                    .frame(
                        maxWidth:.infinity,
                        alignment:.leading
                    )


                }



            }
            .padding()

        }
        .navigationTitle(
            "Detalhes"
        )
        .navigationBarTitleDisplayMode(
            .inline
        )

    }

}
