import Foundation

public struct CharacterDetail: Identifiable, Equatable {
  public let id: Int
  public let comics: [Asset]
  public let series: [Asset]
  public let events: [Asset]
  
  public init(
    id: Int,
    comics: [Asset],
    series: [Asset],
    events: [Asset]
  ) {
    self.id = id
    self.comics = comics
    self.series = series
    self.events = events
  }
}

public struct Asset: Identifiable, Equatable {
  public let id: Int
  public let thumbnail: String?
  
  public init(
    id: Int,
    thumbnail: String? = nil
  ) {
    self.id = id
    self.thumbnail = thumbnail
  }
}

extension CharacterDetail {
  public static func mock(id: Int) -> Self {
    CharacterDetail(
      id: id,
      comics: [],
      series: [],
      events: []
    )
  }
}

extension Asset {
  public static func mock(id: Int) -> Self {
    Asset(id: id)
  }
}
