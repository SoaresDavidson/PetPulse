import Foundation
import Combine

class APIConfig: ObservableObject {
    static let shared = APIConfig()
    @Published var baseURL: String = "http://192.168.128.230:1880"
}
