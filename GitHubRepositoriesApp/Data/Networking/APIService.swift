
import Foundation

enum APIError: Error {
    case invalidURL
    case requestFailed
    case decodingError
}

protocol APIServiceProtocol {
    func fetchData(url: URL) async throws -> Data
}

class APIService: APIServiceProtocol {
    private let session: URLSessionProtocol
    private let token: String?

    init(session: URLSessionProtocol = URLSession.shared, token: String? = nil) {
        self.session = session
        self.token = token
    }

    func fetchData(url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        if let token = token {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw APIError.requestFailed
        }

        return data
    }
}
