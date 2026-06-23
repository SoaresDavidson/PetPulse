import Foundation
import Combine


class PetViewModel: ObservableObject {


    @Published var pets: [Pet] = []



    func carregarPetsDoBanco() {

        pets = [


            Pet(
                nome: "Max",
                raca: "Golden Retriever",
                imagem: "",
                status: "Pronto para retirada!",
                servicos: [
                    "Banho & Tosa",
                    "Hidratação"
                ],
                ultimoServico: "10 Jun"
            ),



            Pet(
                nome: "Luna",
                raca: "Siamês",
                imagem: "",
                status: "Em casa",
                servicos: [
                    "Consulta"
                ],
                ultimoServico: "12 Out"
            ),



            Pet(
                nome: "Thor",
                raca: "Pastor Alemão",
                imagem: "",
                status: "Em atendimento",
                servicos: [
                    "Vacina",
                    "Consulta"
                ]
            )

        ]

    }

}
