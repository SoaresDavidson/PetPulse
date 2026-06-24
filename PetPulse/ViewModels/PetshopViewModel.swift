//
//  PetshopViewModel.swift
//  PetPulse
//
//  Created by Turma02-24 on 22/06/26.
//


import Foundation
import Combine

@MainActor
class PetshopViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var petshops: [Petshop] = []
    @Published var petshopLogado: Petshop? = nil

    var baseURLString: String { "\(APIConfig.shared.baseURL)/petshops" }

    // MARK: - POST (Criar)
    func postPetshop(petshop: Petshop) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(petshop) else {
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

                let decodedResponse = try decoder.decode(Petshop.self, from: data)

                responseMessage = "Sucesso! Petshop criado com ID: \(decodedResponse.id ?? "")"
            } else {
                responseMessage = "Erro no servidor ao criar."
            }
        } catch {
            responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }

    // MARK: - GET (Ler)
    func getPetshops() async {
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

                let decodedPetshops = try decoder.decode([Petshop].self, from: data)

                self.petshops = decodedPetshops
                self.responseMessage = "Sucesso! \(decodedPetshops.count) petshops carregados."

            } else {
                self.responseMessage = "Erro no servidor ao buscar petshops."
            }
        } catch {
            self.responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
        }
    }

    // MARK: - PUT (Atualizar Completo)
    func putPetshop(petshop: Petshop) async {
        isLoading = true
        defer { isLoading = false }

        guard let id = petshop.id,
              let url = URL(string: "\(baseURLString)/\(id)") else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(petshop) else {
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

                self.responseMessage = "Sucesso! Petshop atualizado (PUT)."

            } else {
                self.responseMessage = "Erro no servidor ao atualizar."
            }
        } catch {
            self.responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
    }

    // MARK: - PATCH (Atualizar Parcialmente)
    func patchPetshop(id: String, updates: [String: Any]) async {
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

                self.responseMessage = "Sucesso! Petshop modificado parcialmente (PATCH)."

            } else {
                self.responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            self.responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
    }

    // MARK: - DELETE (Deletar)
    func deletePetshop(id: String) async {
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

                self.responseMessage = "Sucesso! Petshop deletado."

//                 Atualiza a lista local imediatamente
//                self.petshops.removeAll { $0.id == id }

            } else {
                self.responseMessage = "Erro no servidor ao deletar."
            }
        } catch {
            self.responseMessage = "Erro na requisição DELETE: \(error.localizedDescription)"
        }
    }
}
