import Foundation

extension URLSession {
  func data(
    from route: API,
    delegate: (URLSessionTaskDelegate)? = nil
  ) async throws -> (Data, URLResponse) {
    guard let url = route.url else { throw URLError.unknown } /* NB: we need manage custom errors, for now it's ok */
		return try await self.data(from: url, delegate: delegate)
  }
}

extension URLError {
  public static let unknown: Self = URLError(URLError.Code(rawValue: 400))
  
}
