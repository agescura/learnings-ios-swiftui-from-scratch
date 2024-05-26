import SwiftUI

// En la programación, una de las cosas importantes es seguir la filosofía de cada lenguaje. Porque más importante que escribir código, es leerlo. Sobretodo el de otra gente.

// Aquí, en SwiftUI, una vista no la llames home, llámala HomeView. Todas las vistas que sigan el protocolo View, en general, pónle <LOQUESEA>View. Ya veremos, si hacemos algun componente si le llmamamos View o Componente o otra cosa.
struct home: View {
    var body: some View {
        NavigationStack {
					// Aqui PokemonList o PokemonListView son correcto, pero sigue la regla de arriba, PokemonListView
            PokemonList(
                model: PokemonListModel(apiClient: .live)
            )
        }
    }
}

#Preview {
    home()
}
