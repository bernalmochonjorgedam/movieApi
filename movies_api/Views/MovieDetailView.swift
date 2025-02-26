import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel = MovieViewModel()

    var body: some View {
        ScrollView {
            VStack {
                // ✅ Imagen de fondo de la película
                if let posterPath = movie.posterPath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 300)
                    .clipped()
                }

                // ✅ Contenido del detalle
                VStack(alignment: .leading, spacing: 12) {
                    Text(movie.title)
                        .font(.largeTitle)
                        .bold()

                    HStack {
                        Text(movie.releaseDateFormatted())
                            .foregroundColor(.red)
                            .font(.subheadline)
                        Spacer()
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", movie.voteAverage))
                    }

                    Text("Sinopsis")
                        .font(.headline)
                        .padding(.top, 10)

                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.secondary)

                    // ✅ Mostrar los géneros correctamente
                    Text("Categorías")
                        .font(.headline)
                        .padding(.top, 10)

                    HStack {
                        ForEach(viewModel.genreNames(for: movie.genreIDs), id: \.self) { genre in
                            Text(genre)
                                .padding(6)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(5)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
