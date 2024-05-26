
import SwiftUI

enum State {
    case idle
    case isLoading
    case loaded([Pokemon])
    case error(Error)
}

struct PokemonList: View {
    
    @Bindable var model: PokemonListModel = PokemonListModel()
    
    var body: some View {
        
        ZStack {
            List{
                
                ForEach(
                    self.model.pokemonList
                ){ pokemon in
                    
                    
                    HStack(alignment: .center,
                           content: {
                        AsyncImage(
                            url: URL(
                                string:
                                    pokemon.sprites!.front_default
                            ),
                            content: {
                                image in
                                image.resizable()
                                    .aspectRatio(
                                        contentMode: .fit
                                    )
                                    .frame(
                                        maxWidth: 120,
                                        maxHeight: 120
                                    )
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
                        Text(
                            pokemon.name!
                        )
                        
                    })
                    
                    .onTapGesture {
                        self.model.selecPokemon(
                            pokemon
                        )
                    }
                    
                }
                
                
                switch self.model.state {
                
                case .isLoading:
                    ProgressView()
                    
                default:
                        EmptyView()
                }
                    
                
                
            }
            .navigationTitle(
                "PokeDex"
            )
            .onAppear{
                //self.model.fetchPokemones()
        }
            VStack{
                Spacer()
                
                Button(
                    "Añadir pokemon"
                ){
                    self.model.addPokemonToList()
                }
                
            }
            
        }
        .sheet(item: self.$model.pokemonSelected,
               onDismiss: {
            //self.model.selecPokemon(nil)
        } ){ pokemon in
            NavigationStack{
                PokemonDetail(
                    pokemonPage: pokemon,
                    model: PokemonDetailModel(
                        apiClient: .live,
                        pokeListModel: model
                        
                    )
                )
            }
            
        }
        
    }
        
}


@Observable
class PokemonListModel {
    let apiClient: ApiClient
    var pokemonList: [Pokemon]
    var state: State
    
    var pokemonNumber: Int = 0
    var pokemonSelected: Pokemon?
    
    
    
    init(
        apiClient: ApiClient = .mock,
        pokemonList: [Pokemon] = [],
        state: State = .idle

    ){
        self.apiClient = apiClient
        self.pokemonList = pokemonList
        self.state = state
    }
    
    func fetchPokemones(){
        getPokemon(pokemonNumber)
    }
    
    func addPokemonToList(){
        pokemonNumber += 1
        fetchPokemones()
        print(pokemonNumber)
    }
    
    func selecPokemon(_ pokemon: Pokemon?) {
        self.pokemonSelected = pokemon
        print("\(String(describing: pokemon?.id)) \(String(describing: pokemon?.name))" )
    }
        
    
    func getPokemon(_ id: Int) {
        self.state = .isLoading
        Task{
            do {
                let response = try await self.apiClient.getPokemon(id)
                pokemonList.append(response)
                //self.state = .loaded(response)
                self.state = .loaded(pokemonList)
            } catch {
                print(error)
                self.state = .error(error)
            }
        }
    }
    
}



#Preview {
    NavigationStack{
        PokemonList()
    }
}
