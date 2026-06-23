import SwiftUI


struct FilaPetCard: View {


    var agendamento:AgendamentoPet



    var body: some View {


        HStack(spacing:15) {



            VStack {


                Text(
                    agendamento.horario
                )
                .font(
                    .title3.bold()
                )


            }
            .frame(
                width:70
            )






            VStack(
                alignment:.leading,
                spacing:6
            ) {



                Text(
                    agendamento.pet
                )
                .font(
                    .headline
                )



                Text(
                    agendamento.servico
                )
                .font(
                    .subheadline
                )
                .foregroundColor(
                    .gray
                )



            }





            Spacer()



        }
        .padding()



        .background(
            Color.blue.opacity(0.15)
        )



        .clipShape(
            RoundedRectangle(
                cornerRadius:20
            )
        )



    }


}
