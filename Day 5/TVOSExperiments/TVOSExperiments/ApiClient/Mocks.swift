import Dependencies
import Foundation
import XCTestDynamicOverlay

extension ApiClient {
  public static var testValue = Self(
    characters: XCTUnimplemented("\(Self.self).characters"),
    characterDetail: XCTUnimplemented("\(Self.self).characterDetail")
  )
}

extension ApiClient {
  public static var previewValue = Self(
    characters: { [] },
    characterDetail: { .mock(id: $0) }
  )
}
