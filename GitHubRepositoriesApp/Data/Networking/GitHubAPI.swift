
import Foundation

struct GitHubAPI {
    static let baseURL = "https://api.github.com"
    
    static func searchRepositories(query: String, sort: String, order: String, page: Int) -> URL? {
        var components = URLComponents(string: "\(baseURL)/search/repositories")
        components?.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sort", value: sort),
            URLQueryItem(name: "order", value: order),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        return components?.url
    }
}
