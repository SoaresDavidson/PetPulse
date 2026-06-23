import SwiftUI


struct CalendarioFilaView: View {


    @Binding var diaSelecionado:Date



    var body: some View {


        DatePicker(
            "",
            selection:$diaSelecionado,
            displayedComponents:.date
        )
        .datePickerStyle(
            .graphical
        )
        .padding()
        .background(
            Color.white
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius:25
            )
        )


    }


}
