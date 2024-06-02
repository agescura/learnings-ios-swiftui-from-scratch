import Dependencies
import Foundation

extension ApiClient: DependencyKey {
  public static var liveValue: ApiClient = .live
}

extension ApiClient {
  public static var live: Self = {
    let session = URLSession.shared
    let decoder = JSONDecoder()
		
		actor Store {
			nonisolated let offset: ActorIsolated<Int>
			nonisolated let isCalling: ActorIsolated<Bool>
			init() {
				self.offset = ActorIsolated<Int>(0)
				self.isCalling = ActorIsolated<Bool>(false)
			}
		}
		
		let store = Store()
    
    return Self(
      characters: {
				let isCalling = await store.isCalling.value
				print("Actual isCalling: \(isCalling)")
				guard isCalling == false else { return [] }
				let value = await store.offset.value
				print("Actual value: \(value)")
				await store.isCalling.setValue(true)
        let (data, _) = try await session.data(from: Marvel.characters(value))
        /* NB: we need manage custom errors, for now it's ok */
        let characters = try decoder.decode(CharacterResponse.self, from: data)
				await store.offset.setValue(value + 1)
				print("After calling value: \(value + 1)")
				await store.isCalling.setValue(false)
				return characters.data.results.map(Character.init)
      },
      characterDetail: { id in
        // NB: CaseIterable in Marvel.URIType?
        async let (comicsData, _) = try session.data(from: Marvel.uri(id, .comics))
        async let (seriesData, _) = try session.data(from: Marvel.uri(id, .series))
        async let (eventsData, _) = try session.data(from: Marvel.uri(id, .events))
        
        let (
          comicsResponse,
          seriesResponse,
          eventsResponse
        ) = try await (comicsData, seriesData, eventsData)
        
        let comics = try decoder.decode(AssetResponse.self, from: comicsResponse)
        let series = try decoder.decode(AssetResponse.self, from: seriesResponse)
        let events = try decoder.decode(AssetResponse.self, from: eventsResponse)
        
        return CharacterDetail(
          id: id,
          comics: comics.data.results.map(Asset.init),
          series: series.data.results.map(Asset.init),
          events: events.data.results.map(Asset.init)
        )
      }
    )
  }()
}
