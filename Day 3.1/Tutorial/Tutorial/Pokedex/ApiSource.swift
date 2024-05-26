import Foundation

struct ApiClient {
    var getPokemon: (_ id: Int) async throws -> Pokemon
    var getDescription: (_ id: Int) async throws ->
    Pokemon
    //[Pokemon.Description]
}

enum ApiError: Error {
    case unowned
}

extension ApiClient {
    static var live: ApiClient {
        
        return ApiClient(
            getPokemon:  { id in
                let uri = "https://pokeapi.co/api/v2/pokemon/\(id)"
                guard let url = URL(string: uri)
                else { throw ApiError.unowned }
                            
                let (data, _) = try await URLSession.shared.data(from: url)
                let pokemon = try JSONDecoder().decode(Pokemon.self, from: data)
                
                return pokemon
            },
            
            getDescription: { id in
                let uri = "https://pokeapi.co/api/v2/characteristic/\(id)"
                guard let url = URL(string: uri)
                else { throw ApiError.unowned }
                            
                let (data, _) = try await URLSession.shared.data(from: url)
                print(data)
                //let descriptions = try JSONDecoder().decode([Pokemon.Description].self, from: data)
                let descriptions = try JSONDecoder().decode(Pokemon.self, from: data)
                
                print("descripcion")
                print(descriptions)
                
                return descriptions
            }
        )
    }
}

extension ApiClient {
    static var mock: ApiClient {
        
        return ApiClient(
            getPokemon: { id in
                try await Task.sleep(for: .seconds(1))
                return Pokemon.mock
            },
            
            getDescription: { id in
               // return Pokemon.mock.descriptions!
                return Pokemon.mock
            }
            
            
        )
    }
}

extension ApiClient {
    static var error: ApiClient {
        return ApiClient(
            getPokemon: { id in
                //try await Task.sleep(for: .seconds(1))
                throw ApiError.unowned
            },
        
            getDescription: { id in
                throw ApiError.unowned
            }
        )
    }
}
