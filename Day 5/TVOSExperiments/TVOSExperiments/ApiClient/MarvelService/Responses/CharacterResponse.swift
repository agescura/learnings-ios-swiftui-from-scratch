import Foundation

struct CharacterResponse: Decodable {
  let data: Data
  
  struct Data: Decodable {
    let results: [Result]
    
    struct Result: Decodable {
      let id: Int
      let name: String
      let description: String
      let thumbnail: Path
      
      struct Path: Decodable {
        let path: String
        let `extension`: String
      }
    }
  }
}

extension Character {
  init(_ response: CharacterResponse.Data.Result) {
    self.init(
      id: response.id,
      name: response.name,
      description: response.description,
      thumbnail: response.thumbnail.path + "." + response.thumbnail.extension
    )
  }
}
