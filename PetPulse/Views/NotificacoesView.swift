import SwiftUI

struct NotificacoesView: View {
    @EnvironmentObject var notificacaoViewModel: NotificacaoViewModel
    @EnvironmentObject var tutorViewModel: TutorViewModel
    
    private var tutorId: String {
        tutorViewModel.tutorLogado?.id ?? "tutor_1782166739059"
    }
    
    var body: some View {
        NavigationStack {
            List {
                if notificacaoViewModel.notificacoes.isEmpty {
                    Section {
                        HStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "bell.slash")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Nenhuma notificação por aqui.")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                                    .italic()
                            }
                            .padding(.vertical, 32)
                            Spacer()
                        }
                    }
                } else {
                    ForEach(notificacaoViewModel.notificacoes) { notif in
                        NotificationCell(notif: notif)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                if !notif.lida {
                                    Button {
                                        Task {
                                            await markAsRead(notif)
                                        }
                                    } label: {
                                        Label("Marcar como lida", systemImage: "checkmark.circle")
                                    }
                                    .tint(.blue)
                                }
                            }
                            .onTapGesture {
                                if !notif.lida {
                                    Task {
                                        await markAsRead(notif)
                                    }
                                }
                            }
                    }
                }
            }
            .navigationTitle("Notificações")
            .refreshable {
                await notificacaoViewModel.getNotificacoes(tutorId: tutorId)
            }
            .task {
                await notificacaoViewModel.getNotificacoes(tutorId: tutorId)
            }
        }
    }
    
    private func markAsRead(_ notif: Notificacao) async {
        var updated = notif
        updated.lida = true
        await notificacaoViewModel.putNotificacao(tutorId: tutorId, notificacao: updated)
        await notificacaoViewModel.getNotificacoes(tutorId: tutorId)
        
        // Also refresh tutor data to keep counts accurate
        await tutorViewModel.getPerfilLogado(idDoTutorLogado: tutorId)
    }
}

// MARK: - NOTIFICATION CELL COMPONENT
struct NotificationCell: View {
    var notif: Notificacao
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(notif.lida ? Color.gray.opacity(0.1) : Color.blue.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: notif.lida ? "bell" : "bell.badge.fill")
                    .foregroundColor(notif.lida ? .gray : .blue)
                    .font(.system(size: 18))
            }
            .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(notif.titulo)
                        .font(.system(size: 16, weight: notif.lida ? .semibold : .bold))
                        .foregroundColor(notif.lida ? .primary.opacity(0.8) : .primary)
                    
                    Spacer()
                    
                    Text(formatDate(notif.dataEnvio))
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                
                Text(notif.mensagem)
                    .font(.system(size: 14))
                    .foregroundColor(notif.lida ? .gray : .primary.opacity(0.9))
                    .lineLimit(3)
            }
        }
        .padding(.vertical, 6)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
}
