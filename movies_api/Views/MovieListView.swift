import SwiftUI

struct MovieListView: View {
    @StateObject var viewModel = MovieViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText, onSearch: {
                    viewModel.filterMovies()
                })

                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                        ForEach(viewModel.movies) { movie in
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: MovieDetailView(movie: movie)) {
                                    MovieCardView(movie: movie, viewModel: viewModel)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("🎬 Movies")
        }
    }
}
