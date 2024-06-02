import Dependencies
import Foundation

extension DependencyValues {
  public var apiClient: ApiClient {
    get { self[ApiClient.self] }
    set { self[ApiClient.self] = newValue }
  }
}

public struct ApiClient {
  public var characters: @Sendable () async throws -> [Character]
  public var characterDetail: @Sendable (Int) async throws -> CharacterDetail
  
  public init(
    characters: @escaping @Sendable () async throws -> [Character],
    characterDetail: @escaping @Sendable (Int) async throws -> CharacterDetail
  ) {
    self.characters = characters
    self.characterDetail = characterDetail
  }
}
