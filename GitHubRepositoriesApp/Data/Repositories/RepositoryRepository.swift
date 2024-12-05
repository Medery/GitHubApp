
import Foundation

protocol RepositoryRepository {
    func fetchRepositories(query: String, page: Int) async throws -> [Repository]
}

class RepositoryRepositoryImpl: RepositoryRepository {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchRepositories(query: String, page: Int) async throws -> [Repository] {
        guard let url = GitHubAPI.searchRepositories(query: query, sort: "stars", order: "asc", page: page) else {
            throw APIError.invalidURL
        }
        
        let data = try await apiService.fetchData(url: url)
        let decoder = JSONDecoder()
        let response = try decoder.decode(SearchResponse.self, from: data)
        return response.items
    }
}

struct SearchResponse: Codable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [Repository]
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
