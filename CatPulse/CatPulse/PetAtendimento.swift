import Foundation


struct PetAtendimento: Identifiable {


    let id = UUID()


    var nome:String

    var raca:String

    var imagem:String

    var servicos:[String]

    var valor:Double


    var entregue:Bool = false


}
