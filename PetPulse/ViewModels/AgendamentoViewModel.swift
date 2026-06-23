//
//  AgendamentoViewModel.swift
//  PetPulse
//
//  Created by Turma02-24 on 22/06/26.
//

import Foundation
import Combine

@MainActor // Garante que as atualizações de UI (publicações) ocorram na thread principal
class AgendamentoViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var agendamentos: [Scheduling] = [] // Nova lista para armazenar os pets do GET
    
    let baseURLString: String = "http://192.168.128.137:1880/agendamento"
    // MARK: - POST (Criar)
    func postAgendamento(agendamento: Scheduling) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return
        }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let encodedData = try? encoder.encode(agendamento) else {
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
                let decodedResponse = try decoder.decode(Scheduling.self, from: data)
                self.responseMessage = "Sucesso! Agendamento criado com ID: \(decodedResponse.id)"
                
            } else {
                self.responseMessage = "Erro no servidor ao criar."
            }
        } catch {
            self.responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }
    
    // MARK: - GET (Ler)
    func getAgendamentos() async {
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
                // Decodifica um array de Pets
                let decodedPets = try decoder.decode([Scheduling].self, from: data)
                self.agendamentos = decodedPets
                self.responseMessage = "Sucesso! \(decodedPets.count) agendamentos carregados."
                
            } else {
                self.responseMessage = "Erro no servidor ao buscar pets."
            }
        } catch {
            self.responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
        }
    }
    
    // MARK: - PUT (Substituir/Atualizar Completo)
    func putAgendamento(agendamento: Scheduling) async {
        isLoading = true
        defer { isLoading = false }
        
        // Normalmente, o PUT exige o ID na URL
        guard let url = URL(string: "\(baseURLString)/\(agendamento.id)") else {
            responseMessage = "URL inválida."
            return
        }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let encodedData = try? encoder.encode(agendamento) else {
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
                self.responseMessage = "Sucesso! Agendamento atualizado (PUT)."
            } else {
                self.responseMessage = "Erro no servidor ao atualizar."
            }
        } catch {
            self.responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
    }
    
    // MARK: - PATCH (Atualizar Parcialmente)
    // Usamos um dicionário para enviar apenas os campos que mudaram
    func patchAgendamento(id: String, updates: [String: Any]) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "\(baseURLString)/\(id)") else {
            responseMessage = "URL inválida."
            return
        }
        
        // JSONSerialization é ótimo para dicionários dinâmicos (Any)
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
                self.responseMessage = "Sucesso! Agendamento modificado parcialmente (PATCH)."
            } else {
                self.responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            self.responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
    }
    
    // MARK: - DELETE (Deletar)
    func deleteAgendamento(id: String) async {
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
                self.responseMessage = "Sucesso! Agendamento deletado."
                
                // Opcional: Remover o pet da lista localmente para atualizar a UI na mesma hora
                // self.pets.removeAll { $0.id == id }
                
            } else {
                self.responseMessage = "Erro no servidor ao deletar."
            }
        } catch {
            self.responseMessage = "Erro na requisição DELETE: \(error.localizedDescription)"
        }
    }
}

// Helper para filtrar por dia ignorando hora
extension AgendamentoViewModel {
    func agendamentosDoDia(_ dia: Date) -> [Scheduling] {
        let cal = Calendar.current
        return agendamentos.filter { ag in
            cal.isDate(ag.dataHoraAgendamento, inSameDayAs: dia)
        }
    }
}
