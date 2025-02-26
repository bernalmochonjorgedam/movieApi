import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let genreIDs: [Int]?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genreIDs = "genre_ids"
    }

    func releaseDateFormatted() -> String {
        guard let releaseDate = releaseDate else { return "Fecha desconocida" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: releaseDate) {
            formatter.dateFormat = "dd-MM-yyyy"
            return formatter.string(from: date)
        }
        return "Fecha desconocida"
    }
}
