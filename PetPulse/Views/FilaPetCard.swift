import SwiftUI


struct FilaPetCard: View {
    @EnvironmentObject var viewModel: PetViewModel

    var agendamento:Scheduling



    var body: some View {


        HStack(spacing:15) {



            VStack {


                Text(
                    agendamento.dataHoraAgendamento.formatted(
                        date: .omitted,
                        time: .shortened
                    )
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
                    //agendamento.petid
                    "ainda não tem esse get"
                )
                .font(
                    .headline
                )



                Text(
                    //agendamento.serviceId
                    "äinda não tem esse get"
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
