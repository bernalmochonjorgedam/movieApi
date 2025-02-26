import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Buscar película...", text: $text, onEditingChanged: { _ in
                onSearch()
            })
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(8)

            Button(action: {
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
            }
            .padding(.trailing, 10)
        }
        .padding(.horizontal)
    }
}
