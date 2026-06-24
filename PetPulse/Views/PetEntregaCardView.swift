import SwiftUI


struct PetEntregaCardView: View {
    var pet: PetAtendimento
    var entregue: Bool = false
    var acao: () -> Void
    var desfazer: (() -> Void)? = nil
    var body: some View {
        VStack(spacing:15) {
            HStack(spacing:15) {
                // IMAGEM
                RoundedRectangle(
                    cornerRadius:20
                )
                .fill(
                    Color.gray.opacity(0.15)
                )
                .frame(
                    width:80,
                    height:80
                )
                VStack(
                    alignment:.leading,
                    spacing:6
                ) {
                    Text(pet.nome)
                        .font(
                            .title3.bold()
                        )
                    Text(pet.raca)
                        .font(
                            .subheadline
                        )
                    HStack {
                        ForEach(
                            pet.servicos,
                            id:\.self
                        ){ servico in
                            Text(servico)
                                .font(
                                    .caption
                                )
                                .padding(
                                    6
                                )
                                .background(
                                    Color.blue.opacity(0.15)
                                )
                                .clipShape(
                                    Capsule()
                                )
                        }
                    }
                    Text(
                        "R$ \(String(format:"%.2f", pet.valor))"
                    )
                    .font(
                        .headline
                    )
                }
                Spacer()
                // CHECKBOX OU ENTREGUE
                if entregue {
                    Button {
                        desfazer?()
                    } label: {
                        Text("Entregue")
                            .font(
                                .caption.bold()
                            )
                            .foregroundColor(
                                .green
                            )
                    }
                } else {
                    Button {
                        acao()
                    } label: {
                        Image(
                            systemName:
                                "square"
                        )
                        .font(
                            .title2
                        )
                    }
                }
            }
            // BOTÃO NOTIFICAR
            if !entregue {
                Button {
                    print("Notificando \(pet.nome)")
                } label: {
                    HStack {
                        Image(systemName:"bell.fill")
                        Text("Notificar dono")
                        }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth:.infinity)
                    .padding(.vertical,10)
                    .background(Color.orange)
                    .clipShape(Capsule())
                    }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius:25))
        .shadow(radius:5)
    }
}
