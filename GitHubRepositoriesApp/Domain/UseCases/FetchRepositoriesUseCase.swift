
import Foundation
import Combine

protocol FetchRepositoriesUseCase {
    func execute(query: String, page: Int) async throws -> [Repository]
}

class FetchRepositoriesUseCaseImpl: FetchRepositoriesUseCase {
    private let repository: RepositoryRepository
    
    init(repository: RepositoryRepository) {
        self.repository = repository
    }
    
    func execute(query: String, page: Int) async throws -> [Repository] {
        return try await repository.fetchRepositories(query: query, page: page)
    }
}
