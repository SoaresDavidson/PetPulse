import SwiftUI


struct DiaView: View {
    var dia:Date
    var disponivel:Bool
    var body: some View {
        Text(
            dia.formatted(
                .dateTime.day()
            )
        )
        .frame(
            width:40,
            height:40
        )
        .background(
            disponivel ? Color.blue.opacity(0.8): Color.gray.opacity(0.15)
        )
        .foregroundColor(
            disponivel ? .white: .gray
        )
        .clipShape(
            Circle()
        )
    }
}
