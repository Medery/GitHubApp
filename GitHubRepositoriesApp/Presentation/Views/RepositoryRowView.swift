
import SwiftUI

struct RepositoryRowView: View {
    let repository: Repository
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImage(url: URL(string: repository.owner.avatarURL)) { image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text(repository.name)
                    .font(.headline)
                if let description = repository.repoDescription {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(nil)
                }
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(repository.stargazersCount)")
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 5)
    }
}
