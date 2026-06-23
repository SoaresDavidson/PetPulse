import Foundation
import Combine


class AgendamentoViewModel: ObservableObject {


    @Published var agendamentos:[AgendamentoPet] = []



    init() {

        carregarAgendamentos()

    }






    func carregarAgendamentos() {


        let calendario = Calendar.current



        agendamentos = [


            AgendamentoPet(
                data: calendario.date(
                    from: DateComponents(
                        year:2026,
                        month:6,
                        day:22
                    )
                )!,
                horario:"08:00",
                pet:"Max",
                servico:"Banho e Tosa"
            ),




            AgendamentoPet(
                data: calendario.date(
                    from: DateComponents(
                        year:2026,
                        month:6,
                        day:22
                    )
                )!,
                horario:"10:00",
                pet:"Luna",
                servico:"Consulta"
            ),




            AgendamentoPet(
                data: calendario.date(
                    from: DateComponents(
                        year:2026,
                        month:6,
                        day:23
                    )
                )!,
                horario:"14:00",
                pet:"Thor",
                servico:"Vacina"
            ),



            AgendamentoPet(
                data: calendario.date(
                    from: DateComponents(
                        year:2026,
                        month:6,
                        day:23
                    )
                )!,
                horario:"16:00",
                pet:"Mel",
                servico:"Hidratação"
            )


        ]


    }







    func agendamentosDoDia(
        _ dia:Date
    ) -> [AgendamentoPet] {



        agendamentos.filter {


            Calendar.current.isDate(
                $0.data,
                inSameDayAs: dia
            )


        }


    }



}
