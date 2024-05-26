
import SwiftUI


struct PokemonList2: View {
    
    @Bindable var model: PokemonListModel1 = PokemonListModel1()
    
    var body: some View {
        
        ZStack {
            List{
                
                /*
                ForEach(
                    self.model.pokemonList
                ){ pokemon in
                
                    //ItemList(pokemon: pokemon)
                    PokemonCard()
                        .onTapGesture {
                        self.model.selecPokemon(
                            pokemon
                        )
                    }
                    
                }
                */
                
            
                
                
                /*
                for i in 1...3 {
                        EmptyView()
                }
                */
                
                
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
                PokemonDetail.init(
                    pokemonPage: pokemon,
                    model: PokemonDetailModel(
                        apiClient: .live
                        //, pokeListModel: model
                        
                    )
                )
            }
            
        }
        
    }
        
}


@Observable
class PokemonListModel1 {
    let apiClient: ApiClient
    var pokemonList: [Pokemon]
    var state: StateCard
    
    var pokemonNumber: Int = 1
    var pokemonSelected: Pokemon?
    
    
    
    init(
        apiClient: ApiClient = .mock,
        pokemonList: [Pokemon] = [],
        state: StateCard = .idle

    ){
        self.apiClient = apiClient
        self.pokemonList = pokemonList
        self.state = state
    }
    
    func fetchPokemones(){
        //getPokemon(pokemonNumber)
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
        
    
    
    
}


enum StateCard {
    case idle
    case isLoading
    case loaded(Pokemon)
    case error(Error)
}


struct PokemonCard: View {
    
    @Bindable var cardModel: PokemonCardModel = PokemonCardModel()
    
    var body: some View {
        
        switch cardModel.state {
        case .idle:
            EmptyView()
        case .isLoading:
            ProgressView()
        case .loaded(let pokemon):
            HStack(alignment: .center, content: {
                AsyncImage(
                    url: URL(string:
                                pokemon.sprites!.front_default
                            ),
                    content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 120, maxHeight: 120)
                    },
                    placeholder: {
                        ProgressView()
                    }
                )
                Text(pokemon.name!)
                
            })
        case .error(let error):
            Text(error.localizedDescription)
       
        }
        
        
    }
    
}

@Observable
class PokemonCardModel {
    
    var state: StateCard
    //let pokemon: Pokemon
    var listModel: PokemonListModel1 = PokemonListModel1()
    
    
    init(
        state: StateCard = .idle
        //, pokemon: Pokemon = .mock
    ) {
        self.state = state
        //self.pokemon = pokemon
    }
    
    
    func getPokemon(_ id: Int) {
        self.state = .isLoading
        Task{
            do {
                let response = try await self.listModel.apiClient.getPokemon(id)
                
                self.state = .loaded(response)
            } catch {
                print(error)
                self.state = .error(error)
            }
        }
    }
    
    
    
    
}



#Preview {
    NavigationStack{
        PokemonList2()
    }
}
