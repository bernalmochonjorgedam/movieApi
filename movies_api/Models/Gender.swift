import Foundation

struct Genre: Codable, Identifiable {
    let id: Int
    let name: String
}

struct GenreResponse: Codable {
    let genres: [Genre]
}
