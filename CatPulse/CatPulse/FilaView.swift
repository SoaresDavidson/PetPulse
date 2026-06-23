import SwiftUI


struct FilaView: View {


    @StateObject var viewModel =
    AgendamentoViewModel()



    @State private var diaSelecionado =
    Date()



    var body: some View {


        NavigationStack {


            ScrollView {


                VStack(spacing:20) {



                    // CALENDÁRIO

                    CalendarioFilaView(
                        diaSelecionado:$diaSelecionado
                    )






                    // DATA ESCOLHIDA

                    Text(
                        diaSelecionado.formatted(
                            date:.complete,
                            time:.omitted
                        )
                    )
                    .font(
                        .title3.bold()
                    )
                    .frame(
                        maxWidth:.infinity,
                        alignment:.leading
                    )








                    // FILA

                    VStack(
                        alignment:.leading,
                        spacing:15
                    ) {



                        Text(
                            "Fila de atendimento"
                        )
                        .font(
                            .title2.bold()
                        )






                        if viewModel.agendamentosDoDia(
                            diaSelecionado
                        ).isEmpty {



                            Text(
                                "Nenhum animal agendado"
                            )
                            .foregroundColor(
                                .gray
                            )
                            .padding()



                        } else {



                            ForEach(
                                viewModel.agendamentosDoDia(
                                    diaSelecionado
                                )
                            ) { agendamento in



                                FilaPetCard(
                                    agendamento:agendamento
                                )



                            }



                        }




                    }




                }
                .padding()



            }


            .navigationTitle(
                "Fila"
            )


        }


    }


}



#Preview {

    FilaView()

}
