//
//  ItemPedidoViewModel.swift
//  PetPulse
//
//  Created by Turma02-24 on 22/06/26.
//
import Foundation
import Combine
@MainActor
class ItemPedidoViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var itensPedido: [ItemPedido] = []

    let baseURLString: String = "http://192.168.128.137:1880/itensPedido"

    // MARK: - POST
    func postItemPedido(itemPedido: ItemPedido) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(itemPedido) else {
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
                decoder.dateDecodingStrategy = .iso8601

                let decodedResponse = try decoder.decode(ItemPedido.self, from: data)

                responseMessage = "Sucesso! ItemPedido criado com ID: \(decodedResponse.id)"
            } else {
                responseMessage = "Erro no servidor ao criar."
            }
        } catch {
            responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }

    // MARK: - GET
    func getItensPedido() async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let decodedItens = try decoder.decode([ItemPedido].self, from: data)

                itensPedido = decodedItens
                responseMessage = "Sucesso! \(decodedItens.count) itens carregados."
            } else {
                responseMessage = "Erro no servidor ao buscar itens."
            }
        } catch {
            responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
        }
    }

    // MARK: - PUT
    func putItemPedido(itemPedido: ItemPedido) async {
        isLoading = true
        defer { isLoading = false }
        guard let url = URL(string: "\(baseURLString)/\(itemPedido.id)") else {
            return
        }
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(itemPedido) else {
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
                responseMessage = "Sucesso! Pedido de item atualizado (PUT)."
            } else {
                responseMessage = "Erro no servidor ao atualizar."
            }
        } catch {
            responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
        // restante da implementação...
    }

    // MARK: - PATCH
    func patchItemPedido(id: String, updates: [String: Any]) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: "\(baseURLString)/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        guard let encodedData = try? JSONSerialization.data(withJSONObject: updates) else {
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
                responseMessage = "Sucesso! Item modificado parcialmente (PATCH)."
            } else {
                responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
        // mesma implementação do PATCH
    }

    // MARK: - DELETE
    func deleteItemPedido(id: String) async {
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

                responseMessage = "Sucesso! Pedido de item deletado."

                // Atualiza a lista local
             //   itensEstoque.removeAll { $0.id == id }

            } else {
                responseMessage = "Erro no servidor ao deletar."
            }
        } catch {
            responseMessage = "Erro na requisição DELETE: \(error.localizedDescription)"
        }
        // mesma implementação do DELETE
    }
}
