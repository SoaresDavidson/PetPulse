//
//  PedidoViewModel.swift
//  PetPulse
//
//  Created by Turma02-24 on 22/06/26.
//


import Foundation
import Combine

@MainActor
class PedidoViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var pedidos: [Pedido] = []

    var baseURLString: String { "\(APIConfig.shared.baseURL)/pedidos" }

    // MARK: - POST (Criar)
    func postPedido(pedido: Pedido) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(pedido) else {
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

                let decodedResponse = try decoder.decode(Pedido.self, from: data)

                responseMessage = "Sucesso! Pedido criado com ID: \(decodedResponse.id)"
            } else {
                responseMessage = "Erro no servidor ao criar."
            }
        } catch {
            responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }

    // MARK: - GET (Ler)
    func getPedidos() async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: baseURLString) else {
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

                let decodedPedidos = try decoder.decode([Pedido].self, from: data)

                self.pedidos = decodedPedidos
                self.responseMessage = "Sucesso! \(decodedPedidos.count) pedidos carregados."

            } else {
                self.responseMessage = "Erro no servidor ao buscar pedidos."
            }
        } catch {
            self.responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
        }
    }

    // MARK: - PUT (Atualizar Completo)
    func putPedido(pedido: Pedido) async {
        isLoading = true
        defer { isLoading = false }

        guard let id = pedido.id,
              let url = URL(string: "\(baseURLString)/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(pedido) else {
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

                self.responseMessage = "Sucesso! Pedido atualizado (PUT)."

            } else {
                self.responseMessage = "Erro no servidor ao atualizar."
            }
        } catch {
            self.responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
    }

    // MARK: - PATCH (Atualizar Parcialmente)
    func patchPedido(id: String, updates: [String: Any]) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(id)") else {
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

                self.responseMessage = "Sucesso! Pedido modificado parcialmente (PATCH)."

            } else {
                self.responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            self.responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
    }

    // MARK: - DELETE (Deletar)
    func deletePedido(id: String) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {

                self.responseMessage = "Sucesso! Pedido deletado."

                // Atualiza a lista local imediatamente
             //   self.pedidos.removeAll { $0.id == id }

            } else {
                self.responseMessage = "Erro no servidor ao deletar."
            }
        } catch {
            self.responseMessage = "Erro na requisição DELETE: \(error.localizedDescription)"
        }
    }
}
