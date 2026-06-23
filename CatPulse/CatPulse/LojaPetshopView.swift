import SwiftUI


struct LojaPetshopView: View {


    var body: some View {


        NavigationStack {


            VStack {


                Text("Loja Petshop")
                    .font(
                        .largeTitle.bold()
                    )


            }
            .navigationTitle(
                "Loja"
            )


        }


    }


}
