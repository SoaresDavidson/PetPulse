import Foundation
import Combine


class PetshopViewModel: ObservableObject {


    @Published var petsPendentes: [PetAtendimento] = []

    @Published var petsEntregues: [PetAtendimento] = []



    init() {

        carregarPets()

    }





    func carregarPets() {


        petsPendentes = [


            PetAtendimento(
                nome: "Max",
                raca: "Golden Retriever",
                imagem: "",
                servicos: [
                    "Banho",
                    "Tosa"
                ],
                valor: 80
            ),



            PetAtendimento(
                nome: "Luna",
                raca: "Siamês",
                imagem: "",
                servicos: [
                    "Consulta"
                ],
                valor: 120
            ),



            PetAtendimento(
                nome: "Thor",
                raca: "Pastor Alemão",
                imagem: "",
                servicos: [
                    "Vacina",
                    "Consulta"
                ],
                valor: 200
            )


        ]


        petsEntregues = []


    }









    // MARCAR COMO ENTREGUE

    func entregar(
        _ pet: PetAtendimento
    ) {


        petsPendentes.removeAll {

            $0.id == pet.id

        }



        var petEntregue = pet


        petEntregue.entregue = true



        petsEntregues.append(
            petEntregue
        )


    }









    // DESFAZER ENTREGA

    func desfazerEntrega(
        _ pet: PetAtendimento
    ) {


        petsEntregues.removeAll {


            $0.id == pet.id


        }



        var petDevolvido = pet


        petDevolvido.entregue = false



        petsPendentes.append(
            petDevolvido
        )


    }



}
