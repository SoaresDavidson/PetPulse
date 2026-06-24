//
//  VacinaPetViewModel.swift
//  PetPulse
//
//  Created by Turma02-24 on 22/06/26.
//


import Foundation
import Combine

@MainActor
class VacinaPetViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var vacinasPet: [VacinaPet] = []

    var baseURLString: String { "\(APIConfig.shared.baseURL)/vacinasPet" }

    // MARK: - POST (Criar)
    func postVacinaPet(vacinaPet: VacinaPet) async {
        isLoading = true
        defer { isLoading = false }

        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(vacinaPet) else {
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

                let decodedResponse = try decoder.decode(VacinaPet.self, from: data)

                responseMessage = "Sucesso! VacinaPet criada com ID: \(decodedResponse.id ?? 0)"
            } else {
                responseMessage = "Erro no servidor ao criar."
            }
        } catch {
            responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }

    // MARK: - GET (Ler)
    func getVacinasPet() async {
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
                decoder.dateDecodingStrategy = .iso8601

                let decodedVacinasPet = try decoder.decode([VacinaPet].self, from: data)

                self.vacinasPet = decodedVacinasPet
                self.responseMessage = "Sucesso! \(decodedVacinasPet.count) vacinas carregadas."

            } else {
                self.responseMessage = "Erro no servidor ao buscar vacinas."
            }
        } catch {
            self.responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
        }
    }

    // MARK: - PUT (Atualizar Completo)
    func putVacinaPet(vacinaPet: VacinaPet) async {
        isLoading = true
        defer { isLoading = false }

        guard let vacinaId = vacinaPet.id,
              let url = URL(string: "\(baseURLString)/\(vacinaId)") else {
            responseMessage = "URL inválida."
            return
        }

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        guard let encodedData = try? encoder.encode(vacinaPet) else {
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

                self.responseMessage = "Sucesso! VacinaPet atualizada (PUT)."

            } else {
                self.responseMessage = "Erro no servidor ao atualizar."
            }
        } catch {
            self.responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
    }

    // MARK: - PATCH (Atualizar Parcialmente)
    func patchVacinaPet(id: String, updates: [String: Any]) async {
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

                self.responseMessage = "Sucesso! VacinaPet modificada parcialmente (PATCH)."

            } else {
                self.responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            self.responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
    }

    // MARK: - DELETE (Deletar)
    func deleteVacinaPet(id: String) async {
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

                self.responseMessage = "Sucesso! VacinaPet deletada."

                // Atualiza a lista local imediatamente
       //         self.vacinasPet.removeAll { $0.id == id }

            } else {
                self.responseMessage = "Erro no servidor ao deletar."
            }
        } catch {
            self.responseMessage = "Erro na requisição DELETE: \(error.localizedDescription)"
        }
    }
}
