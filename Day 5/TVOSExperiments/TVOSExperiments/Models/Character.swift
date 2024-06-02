import Foundation

public struct Character: Identifiable, Equatable {
  public let id: Int
  public let name: String
  public let description: String
  public let thumbnail: String?
  
  public init(
    id: Int,
    name: String,
    description: String,
    thumbnail: String? = nil
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.thumbnail = thumbnail
  }
}

extension Character {
  public static func mock(id: Int) -> Self {
    Character(
      id: id,
      name: "name",
      description: "description"
    )
  }
}

extension Character {
  public var imageUrl: URL? {
    guard let thumbnail else { return nil }
    return URL(string: thumbnail)
  }
}
