import SwiftUI

struct PokemonDetail: View {
    
    var pokemonPage: Pokemon
    
    var model: PokemonDetailModel
    
    var body: some View {
        
        let pokemon = self.model.pokemonInfo
        
        ScrollView {
            VStack{
                
                HStack {
                    Spacer()
                    VStack(alignment: .trailing){
                        Text(pokemon?.name ?? "").font(.title)
                        Text("ID: \(pokemon?.id ?? 0)").font(.title2)
                    }
                }
                
                
                AsyncImage(
                    url: URL(string:
                                pokemon?.sprites!.front_default ?? ""
                            ),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                        //.frame(maxWidth: 120, maxHeight: 120)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                
                VStack (alignment: .leading) {
                    
                    Text("Descripcion").font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    
                    Text(pokemon?.descriptions?[0].description ?? "hola mundo").font(.title3)
                    
                    Text(pokemon?.descriptions?[0].language.name ?? "en").font(.title3)
                    
                    
                    
                    HStack{ Spacer()}
                    
                    
                }
                
                
            }
            .onAppear {
                self.model.loadinformation(pokemonPage)
            }
            .padding(.all)
        }
        .navigationTitle("Pokemon detail")
        
    }
        
}

@Observable
class PokemonDetailModel {
    
    let apiClient: ApiClient
    
    var pokeListModel: PokemonListModel
    
    var pokemonInfo: Pokemon?
    
    init(
        apiClient: ApiClient = .mock,
        pokeListModel: PokemonListModel = PokemonListModel(),
        pokemonInfo: Pokemon? = nil
    ) {
        self.apiClient = apiClient
        self.pokeListModel = pokeListModel
        self.pokemonInfo = pokemonInfo
    }
    
    func loadinformation(_ pokemon: Pokemon?){
         self.pokemonInfo = pokeListModel.pokemonSelected!
        //self.pokemonInfo = pokemon
        
        getDescription(pokemon?.id)
        
        print("imprime")
        
        print(self.pokemonInfo as Any)
        
        
        
    }
    
    
    
    func getDescription(_ id: Int?) {
        
        if id == nil {
            return
        }
        
        Task{
            do {
                let response = try await self.apiClient.getDescription(id!)
               
                self.pokemonInfo!.descriptions = response.descriptions
                
                
                
            } catch {
                print(error)
            }
        }
    }
    
    
}

#Preview {
    NavigationStack{
        PokemonDetail(pokemonPage: Pokemon.mock, model: PokemonDetailModel())
    }
}
