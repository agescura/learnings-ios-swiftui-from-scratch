import Foundation

extension Marvel: API {
  var scheme: HTTPScheme {
    .https
  }
  
  var baseURL: String {
    "gateway.marvel.com"
  }
  
  var port: Int {
    443
  }
  
  var prefix: String {
    "/v1/public"
  }
  
  var path: String {
    switch self {
    case .characters:
      return "/characters"
    case let .uri(id, type):
      return "/characters/\(id)/\(type.rawValue)"
    }
  }
  
  var parameters: [URLQueryItem] {
    let timestamp = formatter.string(from: Date())
    var params = [
      URLQueryItem(name: "apikey", value: publicKey),
      URLQueryItem(name: "hash", value: "\(timestamp)\(privateKey)\(publicKey)".md5),
      URLQueryItem(name: "ts", value: timestamp)
    ]
    switch self {
    case let .characters(offset):
				params.append(URLQueryItem(name: "offset", value: "\(offset)"))
			case .uri:
				break
    }
    return params
  }
  
  var method: HTTPMethod {
    switch self {
    case .characters, .uri:
        return .get
    }
  }
}

let formatter = {
  let formatter = DateFormatter()
  formatter.dateFormat = "yyyyMMddHHmmss"
  return formatter
}()
