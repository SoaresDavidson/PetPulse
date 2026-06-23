import Foundation
import Combine

@MainActor // Garante que as atualizações de UI (publicações) ocorram na thread principal
class PetViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var pets: [Pet] = [] // Nova lista para armazenar os pets do GET
    
    let baseURLString: String = "http://192.168.128.137:1880/pets"
    // MARK: - POST (Criar)
    func postPet(pet: Pet) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return
        }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let encodedData = try? encoder.encode(pet) else {
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
                let decodedResponse = try decoder.decode(Pet.self, from: data)
                self.responseMessage = "Sucesso! Pet criado com ID: \(decodedResponse.id ?? "")"
                
            } else {
                self.responseMessage = "Erro no servidor ao criar."
            }
        } catch {
            self.responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }
    
    // MARK: - GET (Ler)
    func getPets() async -> [Pet]? {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return nil
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
                let decodedPets = try decoder.decode([Pet].self, from: data)
                self.pets = decodedPets
                self.responseMessage = "Sucesso! \(decodedPets.count) pets carregados."
                return decodedPets
            } else {
                self.responseMessage = "Erro no servidor ao buscar pets."
                return nil
            }
        } catch {
            self.responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
            return nil
        }
    }
    
    // MARK: - PUT (Substituir/Atualizar Completo)
    func putPet(pet: Pet) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let id = pet.id,
              let url = URL(string: "\(baseURLString)/\(id)") else {
            responseMessage = "URL inválida."
            return
        }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let encodedData = try? encoder.encode(pet) else {
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
                self.responseMessage = "Sucesso! Pet atualizado (PUT)."
            } else {
                self.responseMessage = "Erro no servidor ao atualizar."
            }
        } catch {
            self.responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
    }
    
    // MARK: - PATCH (Atualizar Parcialmente)
    // Usamos um dicionário para enviar apenas os campos que mudaram
    func patchPet(id: String, updates: [String: Any]) async {
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
                self.responseMessage = "Sucesso! Pet modificado parcialmente (PATCH)."
            } else {
                self.responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            self.responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
    }
    
    // MARK: - DELETE (Deletar)
    func deletePet(id: String) async {
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
                self.responseMessage = "Sucesso! Pet deletado."
                
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
