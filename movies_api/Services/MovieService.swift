import Foundation

class MovieService {
    private let baseURL = Config.baseURL
    private let accessToken = Config.accessToken

    private var genreDict: [Int: String] = [:]

    func fetchTopMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)discover/movie?include_adult=false&include_video=false&language=es-ES&page=1&sort_by=vote_average.desc&without_genres=99,10755&vote_count.gte=200"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL inválida", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Datos inválidos", code: -1, userInfo: nil)))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("🔍 JSON de películas recibido: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse.results))
                }
            } catch {
                print("❌ Error al decodificar películas: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchGenres(completion: @escaping (Result<[Genre], Error>) -> Void) {
        let urlString = "\(baseURL)genre/movie/list?language=es-ES"

        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "URL inválida", code: -1, userInfo: nil)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Datos inválidos", code: -1, userInfo: nil)))
                return
            }

            if let jsonString = String(data: data, encoding: .utf8) {
                print("🔍 JSON de géneros recibido: \(jsonString)")
            }

            do {
                let decodedResponse = try JSONDecoder().decode(GenreResponse.self, from: data)
                DispatchQueue.main.async {
                    self.genreDict = Dictionary(uniqueKeysWithValues: decodedResponse.genres.map { ($0.id, $0.name) })
                    print("✅ Géneros almacenados correctamente: \(self.genreDict)")
                    completion(.success(decodedResponse.genres))
                }
            } catch {
                print("❌ Error al decodificar géneros: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }

    func genreName(for id: Int) -> String {
        let genre = genreDict[id] ?? "Desconocido"
        print("🎭 Buscando género para ID \(id): \(genre)")
        return genre
    }
}
