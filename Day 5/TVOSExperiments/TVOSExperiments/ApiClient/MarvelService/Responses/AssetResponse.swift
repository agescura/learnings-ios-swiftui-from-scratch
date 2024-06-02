import Foundation

struct AssetResponse: Decodable {
  let data: Data
  
  struct Data: Decodable {
    let results: [Result]
		let offset: Int
    
    struct Result: Decodable {
      let id: Int
      let thumbnail: Path
      
      struct Path: Decodable {
        let path: String
        let `extension`: String
      }
    }
  }
}

extension Asset {
  init(_ response: AssetResponse.Data.Result) {
    self.init(
      id: response.id,
      thumbnail: response.thumbnail.path + "." + response.thumbnail.extension
    )
  }
}
