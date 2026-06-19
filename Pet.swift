import Foundation


struct Pet: Identifiable {

    let id: UUID
    
    var nome: String?
    var raca: String?
    var imagem: String?
    var status: String?
    var servicos: [String]?
    var ultimoServico: String?



    init(
        id: UUID = UUID(),
        nome: String? = nil,
        raca: String? = nil,
        imagem: String? = nil,
        status: String? = nil,
        servicos: [String]? = nil,
        ultimoServico: String? = nil
    ) {

        self.id = id
        self.nome = nome
        self.raca = raca
        self.imagem = imagem
        self.status = status
        self.servicos = servicos
        self.ultimoServico = ultimoServico
    }
}
