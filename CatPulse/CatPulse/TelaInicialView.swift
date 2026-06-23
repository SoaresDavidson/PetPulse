import SwiftUI


struct TelaInicialView: View {


    var body: some View {


        NavigationStack {


            VStack(spacing:40) {



                Spacer()



                Text("CatPulse")
                    .font(
                        .largeTitle.bold()
                    )



                Text("Escolha uma opção")
                    .font(
                        .title3
                    )
                    .foregroundColor(.gray)




                VStack(spacing:20) {



                    NavigationLink {


                            ClienteHomeView()


                    } label: {


                        Text("Cliente")
                            .font(
                                .title2.bold()
                            )
                            .foregroundColor(.white)
                            .frame(
                                maxWidth:.infinity
                            )
                            .padding()
                            .background(
                                Color.blue
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius:20
                                )
                            )


                    }





                    NavigationLink {


                        PetshopHomeView()


                    } label: {


                        Text("Petshop")
                            .font(
                                .title2.bold()
                            )
                            .foregroundColor(.white)
                            .frame(
                                maxWidth:.infinity
                            )
                            .padding()
                            .background(
                                Color.orange
                            )
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius:20
                                )
                            )


                    }



                }
                .padding(.horizontal,40)



                Spacer()



            }
            .navigationTitle("")
            .navigationBarHidden(true)



        }


    }


}
