import Foundation
import Combine

@MainActor
class ServiceViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var services: [Service] = []

    var baseURLString: String { "\(APIConfig.shared.baseURL)/petshops" }

    // MARK: - POST (Criar)
    func postService(petshopId: String = "petshop_teste", service: Service) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(petshopId)/servicos") else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(service) else {
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

                let decodedResponse = try decoder.decode(Service.self, from: data)

                responseMessage = "Sucesso! Service criado com ID: \(decodedResponse.id ?? 0)"
            } else {
                responseMessage = "Erro no servidor ao criar."
            }
        } catch {
            responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }

    // MARK: - GET (Ler)
    func getServices(petshopId: String = "petshop_teste") async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(petshopId)/servicos") else {
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

                let decodedServices = try decoder.decode([Service].self, from: data)

                self.services = decodedServices
                self.responseMessage = "Sucesso! \(decodedServices.count) services carregados."

            } else {
                self.responseMessage = "Erro no servidor ao buscar services."
            }
        } catch {
            self.responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
        }
    }

    // MARK: - PUT (Atualizar Completo)
    func putService(petshopId: String = "petshop_teste", service: Service) async {
        isLoading = true
        defer { isLoading = false }

        guard let id = service.id,
              let url = URL(string: "\(baseURLString)/\(petshopId)/servicos/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(service) else {
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

                self.responseMessage = "Sucesso! Service atualizado (PUT)."

            } else {
                self.responseMessage = "Erro no servidor ao atualizar."
            }
        } catch {
            self.responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
    }

    // MARK: - PATCH (Atualizar Parcialmente)
    func patchService(petshopId: String = "petshop_teste", id: String, updates: [String: Any]) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(petshopId)/servicos/\(id)") else {
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

                self.responseMessage = "Sucesso! Service modificado parcialmente (PATCH)."

            } else {
                self.responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            self.responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
    }

    // MARK: - DELETE (Deletar)
    func deleteService(petshopId: String = "petshop_teste", id: String) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(petshopId)/servicos/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {

                self.responseMessage = "Sucesso! Service deletado."

            } else {
                self.responseMessage = "Erro no servidor ao deletar."
            }
        } catch {
            self.responseMessage = "Erro na requisição DELETE: \(error.localizedDescription)"
        }
    }
}
