import SwiftUI

struct home: View {
    var body: some View {
        NavigationStack {
            PokemonList(
                model: PokemonListModel(apiClient: .live)
            )
        }
    }
}

#Preview {
    home()
}
