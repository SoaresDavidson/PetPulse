import SwiftUI


struct AgendarView: View {


    var pet: Pet



    @State private var diaSelecionado: Date?



    var body: some View {


        NavigationStack {


            VStack(spacing:20) {



                Text("Agendar serviço")
                    .font(
                        .largeTitle.bold()
                    )



                Text(
                    "Para \(pet.nome ?? "Pet")"
                )
                .font(
                    .title3
                )



                CalendarioView(
                    diaSelecionado:$diaSelecionado,
                    mostrarHorarios:.constant(false)
                )



                Spacer()



            }
            .padding()



            .navigationTitle(
                "Agendamento"
            )



        }


    }


}
