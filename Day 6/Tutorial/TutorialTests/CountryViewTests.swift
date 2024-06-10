import XCTest
@testable import Tutorial
import SnapshotTesting

//final class CountryViewTests: XCTestCase {
//	
//	func testHappyPath() {
//		let model = CountryModel(
//			apiClient: .mock
//		)
//		
//		XCTAssertEqual(model.state, .idle)
//		
//		model.fetchCountries()
//		
//		XCTAssertEqual(model.state, .isLoading)
//		
//		_ = XCTWaiter.wait(for: [.init()], timeout: 1)
//		
//		XCTAssertEqual(model.state, .loaded(
//			[
//				Country(
//					flags: Country.Flags(png: ""),
//					name: Country.Name(common: "Spain", official: "Spain")
//				),
//				Country(
//					flags: Country.Flags(png: ""),
//					name: Country.Name(common: "Colombia", official: "Colombia")
//				)
//			]
//		))
//		
//		model.selectButtonTapped(
//			country:
//				Country(
//					flags: Country.Flags(png: ""),
//					name: Country.Name(common: "Spain", official: "Spain")
//				)
//		)
//		
//		XCTAssertEqual(
//			model.countrySelected,
//			Country(
//				flags: Country.Flags(png: ""),
//				name: Country.Name(common: "Spain", official: "Spain")
//			)
//		)
//	}
//	
//	func testSnapshot() {
//		let model = CountryModel(apiClient: .init(fetchCountries: {
//			[
//				Country(
//					flags: Country.Flags(png: ""),
//					name: Country.Name(common: "Spain", official: "Spain")
//				),
//				Country(
//					flags: Country.Flags(png: ""),
//					name: Country.Name(common: "Colombia", official: "Colombia")
//				)
//			]
//		}))
//		let view = CountryView(model: model)
//		assertSnapshots(
//			of: view,
//			as: [.image]
//		)
//	}
//}
