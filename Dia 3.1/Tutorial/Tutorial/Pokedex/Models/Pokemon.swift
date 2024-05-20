import Foundation

struct Pokemon: Identifiable, Decodable, Equatable {
    var id: Int
    
    var name: String?
    var sprites: Sprites?
    
    var descriptions: [Description]?
    
    
    struct Sprites: Decodable, Equatable {
        let front_default: String
        let back_default: String
    }
    
    struct Description: Decodable, Equatable {
        let description: String
        let language: Language
    }
    
    struct Language: Decodable, Equatable {
        let name: String
    }
    
}

extension Pokemon {
    static var mock: Pokemon = Pokemon(
        id: 0,
        name: "Poke",
        sprites: Pokemon.Sprites(
            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
            back_default: ""
        ),
        descriptions: [Pokemon.Description(description: "Descripcion mock 1", language: Pokemon.Language(name:  "mock1")),
                       Pokemon.Description(description: "Descripcion mock 2", language: Pokemon.Language(name:  "mock2"))]
    )
}


