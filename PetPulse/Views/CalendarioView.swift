import SwiftUI

// CALENDARIO EM "GENDAR"NA ABA HOME DO CLIENTE
struct CalendarioView: View {


    @Binding var diaSelecionado: Date?
    @Binding var mostrarHorarios: Bool


    @State private var mes = Date()


    let calendario = Calendar.current



    var diasDoMes: [Date] {


        guard let intervalo =
                calendario.dateInterval(
                    of: .month,
                    for: mes
                )
        else {

            return []

        }



        var datas: [Date] = []


        var dataAtual = intervalo.start



        while dataAtual < intervalo.end {


            datas.append(dataAtual)



            dataAtual = calendario.date(
                byAdding: .day,
                value: 1,
                to: dataAtual
            )!


        }



        return datas


    }





    var body: some View {


        VStack(spacing:20) {



            // CABEÇALHO DO MÊS

            HStack {


                Button {


                    mes = calendario.date(
                        byAdding: .month,
                        value: -1,
                        to: mes
                    )!



                } label: {


                    Image(
                        systemName:"chevron.left"
                    )


                }




                Spacer()



                Text(
                    mes.formatted(
                        .dateTime
                            .month(.wide)
                            .year()
                    )
                )
                .font(
                    .headline
                )



                Spacer()



                Button {


                    mes = calendario.date(
                        byAdding: .month,
                        value: 1,
                        to: mes
                    )!



                } label: {


                    Image(
                        systemName:"chevron.right"
                    )


                }


            }
            .padding(.horizontal)







            // DIAS DA SEMANA

            HStack {


                ForEach(
                    ["D","S","T","Q","Q","S","S"],
                    id:\.self
                ) { dia in


                    Text(dia)
                        .frame(
                            maxWidth:.infinity
                        )
                        .font(
                            .caption.bold()
                        )


                }


            }
            .padding(.horizontal)









            // DIAS

            LazyVGrid(
                columns:
                    Array(
                        repeating:
                            GridItem(.flexible()),
                        count:7
                    ),
                spacing:15
            ) {



                ForEach(
                    diasDoMes,
                    id:\.self
                ) { dia in



                    DiaView(
                        dia:dia,
                        disponivel:diaDisponivel(dia)
                    )
                    .onTapGesture {


                        if diaDisponivel(dia) {


                            diaSelecionado = dia


                        }


                    }



                }



            }
            .padding(.horizontal)



        }


    }







    private func diaDisponivel(_ dia: Date) -> Bool {
        let numero = calendario.component(.day, from: dia)
        // Apenas para teste: dias pares disponíveis
        return numero % 2 == 0
    }



}
