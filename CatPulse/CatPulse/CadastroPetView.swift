import SwiftUI

// CADASTRAR PET NO HOME DO PETSHOP

struct CadastroPetView: View {


    var body: some View {


        VStack {


            Text("Cadastrar novo pet")
                .font(
                    .largeTitle.bold()
                )


        }
        .navigationTitle(
            "Cadastro"
        )


    }


}


#Preview {

    CadastroPetView()

}
