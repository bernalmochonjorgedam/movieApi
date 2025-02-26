import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var genres: [Genre] = []
    @Published var searchText: String = ""

    private var allMovies: [Movie] = []
    private let movieService = MovieService()
    
    init() {
        fetchGenres { [weak self] in
            self?.fetchMovies()
        }
    }

    func fetchGenres(completion: @escaping () -> Void) {
        movieService.fetchGenres { [weak self] result in
            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self?.genres = genres
                    print("✅ Géneros obtenidos y almacenados correctamente en ViewModel.")
                    completion()
                }
            case .failure(let error):
                print("❌ Error obteniendo géneros: \(error.localizedDescription)")
            }
        }
    }

    func fetchMovies() {
        movieService.fetchTopMovies { [weak self] result in
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self?.allMovies = movies
                    self?.movies = movies

                    movies.forEach { movie in
                        let genreNames = self?.genreNames(for: movie.genreIDs) ?? []
                        print("🎬 \(movie.title) - Géneros: \(genreNames)")
                    }

                    self?.objectWillChange.send()
                }
            case .failure(let error):
                print("❌ Error obteniendo películas: \(error.localizedDescription)")
            }
        }
    }

    func genreNames(for ids: [Int]?) -> [String] {
        guard let ids = ids else { return [] }

        let genreNames = ids.compactMap { id in
            let name = movieService.genreName(for: id)
            print("🎭 ID de género: \(id) - Nombre obtenido: \(name)")
            return name
        }

        return genreNames
    }

    func filterMovies() {
        if searchText.isEmpty {
            movies = allMovies
        } else {
            movies = allMovies.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
}
