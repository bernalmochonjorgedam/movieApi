import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    @ObservedObject var viewModel: MovieViewModel  

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .topTrailing) {
                if let posterPath = movie.posterPath {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 170, height: 250)
                    .cornerRadius(12)
                }

                Text(String(format: "%.1f", movie.voteAverage))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color.red))
                    .offset(x: -10, y: 10)
            }

            Text(movie.title)
                .font(.headline)
                .foregroundColor(.black)
                .lineLimit(1)
                .padding(.top, 5)

            HStack {
                ForEach(viewModel.genreNames(for: movie.genreIDs).prefix(1), id: \.self) { genre in
                    Text(genre)
                        .font(.caption)
                        .padding(6)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .frame(width: 170)
    }
}
