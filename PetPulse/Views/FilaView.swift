import SwiftUI

struct FilaView: View {

    @EnvironmentObject var agendamentoViewModel: AgendamentoViewModel

    @State private var diaSelecionado = Date()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:20) {

                    // CALENDÁRIO
                    CalendarioFilaView(
                        diaSelecionado: $diaSelecionado
                    )

                    // DATA ESCOLHIDA
                    Text(
                        diaSelecionado.formatted(
                            date: .complete,
                            time: .omitted
                        )
                    )
                    .font(.title3.bold())
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )

                    // FILA
                    VStack(
                        alignment: .leading,
                        spacing: 15
                    ) {
                        Text("Fila de atendimento")
                            .font(.title2.bold())

                        let doDia = agendamentoViewModel.agendamentosDoDia(diaSelecionado)

                        if doDia.isEmpty {
                            Text("Nenhum animal agendado")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(doDia) { agendamento in
                                FilaPetCard(agendamento: agendamento)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Fila")
        }
        .task {
            // Carrega os agendamentos ao entrar na tela
            await agendamentoViewModel.getAgendamentos()
        }
    }
}

#Preview {
    FilaView()
        .environmentObject(AgendamentoViewModel())
}
