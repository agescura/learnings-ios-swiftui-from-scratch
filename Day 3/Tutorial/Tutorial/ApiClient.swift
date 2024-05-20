import Foundation
import Dependencies

extension DependencyValues {
	var apiClient: ApiClient {
		get { self[ApiClient.self] }
		set { self[ApiClient.self] = newValue }
	}
}


struct ApiClient {
	var fetchCountries: () async throws -> [Country]
}

enum ApiError: Error, Equatable {
	case unknown
}

extension ApiClient: DependencyKey {
	static var liveValue: ApiClient {
		
		return ApiClient(
			fetchCountries: {
				guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags")
				else { throw ApiError.unknown }
				
				let (data, _) = try await URLSession.shared.data(from: url)
				let countries = try JSONDecoder().decode([Country].self, from: data)
				
				return countries
			}
		)
	}
}

extension ApiClient: TestDependencyKey {
	static var previewValue: ApiClient {
		return ApiClient(
			fetchCountries: {
				try await Task.sleep(for: .seconds(1))
				return [
					Country(
						flags: Country.Flags(png: ""),
						name: Country.Name(common: "Spain", official: "Spain")
					),
					Country(
						flags: Country.Flags(png: ""),
						name: Country.Name(common: "Colombia", official: "Colombia")
					)
				]
			}
		)
	}
}

extension	ApiClient {
	static var testValue: ApiClient {
		return ApiClient(
			fetchCountries: {
				try await Task.sleep(for: .seconds(1))
				throw ApiError.unknown
			}
		)
	}
}
