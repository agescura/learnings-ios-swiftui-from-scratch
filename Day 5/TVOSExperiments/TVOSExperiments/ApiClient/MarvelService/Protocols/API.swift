import Foundation

protocol API {
  var scheme: HTTPScheme { get }
  var baseURL: String { get }
  var port: Int { get }
  var prefix: String { get }
  var path: String { get }
  var parameters: [URLQueryItem] { get }
  var method: HTTPMethod { get }
}

extension API {
  var url: URL? {
    var components = URLComponents()
    components.scheme = self.scheme.rawValue
    components.host = self.baseURL
    components.port = self.port
    components.path = self.prefix + self.path
    components.queryItems = self.parameters
    return components.url
  }
}
