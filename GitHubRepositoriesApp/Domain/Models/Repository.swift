
import Foundation

struct Repository: Identifiable, Codable {
    let id: Int
    var name: String
    let fullName: String
    var repoDescription: String?
    let stargazersCount: Int
    let owner: Owner
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case repoDescription = "description"
        case stargazersCount = "stargazers_count"
        case owner
    }
}

struct Owner: Codable {
    let login: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
