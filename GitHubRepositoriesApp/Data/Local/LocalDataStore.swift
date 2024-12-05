import Foundation
import SwiftData

@Model
class LocalRepository: Identifiable {
    @Attribute(.unique) var id: Int
    var name: String
    var fullName: String
    var repoDescription: String?
    var stargazersCount: Int
    var ownerLogin: String
    var ownerAvatarURL: String
    
    init(id: Int, name: String, fullName: String, repoDescription: String?, stargazersCount: Int, ownerLogin: String, ownerAvatarURL: String) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.repoDescription = repoDescription
        self.stargazersCount = stargazersCount
        self.ownerLogin = ownerLogin
        self.ownerAvatarURL = ownerAvatarURL
    }
}
