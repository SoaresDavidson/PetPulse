import Foundation
import Combine

@MainActor
class NotificacaoViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var notificacoes: [Notificacao] = []

    var baseURLString: String { "\(APIConfig.shared.baseURL)/tutores" }

    // MARK: - POST (Criar)
    func postNotificacao(tutorId: String = "tutor_1782166739059", notificacao: Notificacao) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(tutorId)/notificacoes") else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(notificacao) else {
            responseMessage = "Falha ao codificar os dados."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .customFlexible

                let decodedResponse = try decoder.decode(Notificacao.self, from: data)

                responseMessage = "Sucesso! Notificação criada com ID: \(decodedResponse.id ?? 0)"
            } else {
                responseMessage = "Erro no servidor ao criar."
            }
        } catch {
            responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }

    // MARK: - GET (Ler)
    func getNotificacoes(tutorId: String = "tutor_1782166739059") async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(tutorId)/notificacoes") else {
            responseMessage = "URL inválida."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .customFlexible

                let decodedNotificacoes = try decoder.decode([Notificacao].self, from: data)

                self.notificacoes = decodedNotificacoes
                self.responseMessage = "Sucesso! \(decodedNotificacoes.count) notificações carregadas."

            } else {
                self.responseMessage = "Erro no servidor ao buscar notificações."
            }
        } catch {
            self.responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
        }
    }

    // MARK: - PUT (Atualizar Completo)
    func putNotificacao(tutorId: String = "tutor_1782166739059", notificacao: Notificacao) async {
        isLoading = true
        defer { isLoading = false }

        guard let id = notificacao.id,
              let url = URL(string: "\(baseURLString)/\(tutorId)/notificacoes/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(notificacao) else {
            responseMessage = "Falha ao codificar os dados."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {

                self.responseMessage = "Sucesso! Notificação atualizada (PUT)."

            } else {
                self.responseMessage = "Erro no servidor ao atualizar."
            }
        } catch {
            self.responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
    }

    // MARK: - PATCH (Atualizar Parcialmente)
    func patchNotificacao(tutorId: String = "tutor_1782166739059", id: String, updates: [String: Any]) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(tutorId)/notificacoes/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        guard let encodedData = try? JSONSerialization.data(withJSONObject: updates, options: []) else {
            responseMessage = "Falha ao codificar os dados do Patch."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = encodedData

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {

                self.responseMessage = "Sucesso! Notificação modificada parcialmente (PATCH)."

            } else {
                self.responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            self.responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
    }

    // MARK: - DELETE (Deletar)
    func deleteNotificacao(tutorId: String = "tutor_1782166739059", id: String) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(tutorId)/notificacoes/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {

                self.responseMessage = "Sucesso! Notificação deletada."

            } else {
                self.responseMessage = "Erro no servidor ao deletar."
            }
        } catch {
            self.responseMessage = "Erro na requisição DELETE: \(error.localizedDescription)"
        }
    }
}
