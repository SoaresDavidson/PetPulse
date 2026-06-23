import Foundation


struct AgendamentoPet: Identifiable {


    let id = UUID()


    var data: Date

    var horario: String

    var pet: String

    var servico: String


}
