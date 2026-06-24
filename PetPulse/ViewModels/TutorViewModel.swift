import Foundation
import Combine

@MainActor
class TutorViewModel: ObservableObject {
    @Published var responseMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var tutores: [Tutor] = []
    @Published var tutorLogado: Tutor?
    var baseURLString: String { "\(APIConfig.shared.baseURL)/tutores" }
    
    // Formatter para datas no formato "yyyy-MM-dd"
    private static let ymdFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    // Busca o tutor específico pelo ID
    func getPerfilLogado(idDoTutorLogado: String) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "\(baseURLString)/\(idDoTutorLogado)") else {
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
                let tutor = try decoder.decode(Tutor.self, from: data)
                
                self.tutorLogado = tutor
                self.responseMessage = "Perfil carregado com sucesso!"
                
            } else {
                self.responseMessage = "Erro ao buscar perfil."
            }
        } catch {
            self.responseMessage = "Erro na requisição: \(error.localizedDescription)"
        }
    }
    // MARK: - POST (Criar)
    func postTutor(tutor: Tutor) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: baseURLString) else {
            responseMessage = "URL inválida."
            return
        }
        
        let encoder = JSONEncoder()
        // Se você envia datas como "yyyy-MM-dd", pode usar o mesmo formatter.
        // Caso sua API exija outro formato para POST, ajuste aqui.
        encoder.dateEncodingStrategy = .formatted(Self.ymdFormatter)
        guard let encodedData = try? encoder.encode(tutor) else {
            responseMessage = "Falha ao codificar os dados do Tutor."
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
                decoder.dateDecodingStrategy = .formatted(Self.ymdFormatter)
                let decodedResponse = try decoder.decode(Tutor.self, from: data)
                self.responseMessage = "Sucesso! Tutor criado com ID: \(decodedResponse.id ?? "")"
                
            } else {
                self.responseMessage = "Erro no servidor ao criar Tutor."
            }
        } catch {
            self.responseMessage = "Erro na requisição POST: \(error.localizedDescription)"
        }
    }
    
    // MARK: - GET (Ler)
    func getTutores() async {
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
                let decodedTutores = try decoder.decode([Tutor].self, from: data)
                self.tutores = decodedTutores
                self.responseMessage = "Sucesso! \(decodedTutores.count) tutores carregados."
                
            } else {
                self.responseMessage = "Erro no servidor ao buscar tutores."
            }
        } catch {
            self.responseMessage = "Erro na requisição GET: \(error.localizedDescription)"
        }
    }
    
    // MARK: - PUT (Atualizar Completo)
    func putTutor(tutor: Tutor) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let tutorId = tutor.id,
              let url = URL(string: "\(baseURLString)/\(tutorId)") else {
            responseMessage = "URL inválida ou ID do tutor ausente."
            return
        }
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(Self.ymdFormatter)
        guard let encodedData = try? encoder.encode(tutor) else {
            responseMessage = "Falha ao codificar os dados do Tutor."
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
                self.responseMessage = "Sucesso! Tutor atualizado (PUT)."
            } else {
                self.responseMessage = "Erro no servidor ao atualizar Tutor."
            }
        } catch {
            self.responseMessage = "Erro na requisição PUT: \(error.localizedDescription)"
        }
    }
    
    // MARK: - PATCH (Atualizar Parcialmente)
    func patchTutor(id: String, updates: [String: Any]) async {
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
                self.responseMessage = "Sucesso! Tutor modificado parcialmente (PATCH)."
            } else {
                self.responseMessage = "Erro no servidor ao aplicar PATCH."
            }
        } catch {
            self.responseMessage = "Erro na requisição PATCH: \(error.localizedDescription)"
        }
    }
    
    // MARK: - DELETE (Deletar)
    // Opcional: Adicionei o parâmetro 'rev' caso seu banco de dados exija para deleção
    func deleteTutor(id: String, rev: String? = nil) async {
        isLoading = true
        defer { isLoading = false }
        
        var urlString = "\(baseURLString)/\(id)"
        
        // Se houver um _rev e a API precisar dele por query string
        if let rev = rev {
            urlString += "?rev=\(rev)"
        }
        
        guard let url = URL(string: urlString) else {
            responseMessage = "URL inválida."
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {
                self.responseMessage = "Sucesso! Tutor deletado."
                
                // Atualiza a lista local removendo o tutor deletado
                self.tutores.removeAll { $0.id == id }
                
            } else {
                self.responseMessage = "Erro no servidor ao deletar Tutor."
            }
        } catch {
            self.responseMessage = "Erro na requisição DELETE: \(error.localizedDescription)"
        }
    }
}
