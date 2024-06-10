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
	var fetchWeather: () async throws -> Weather
}

enum ApiError: Error, Equatable {
	case unknown
}

extension ApiClient: DependencyKey {
	static var liveValue: Self {
		Self(
			fetchCountries: {
				guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags")
				else { throw ApiError.unknown }
				
				let (data, _) = try await URLSession.shared.data(from: url)
				let countries = try JSONDecoder().decode([Country].self, from: data)
				
				return countries
			},
			fetchWeather: {
				guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=6.2546168&longitude=-75.5899082&current=temperature_2m")
				else { throw ApiError.unknown }
				
				let (data, _) = try await URLSession.shared.data(from: url)
				let jsonDecoder = JSONDecoder()
				
				return try jsonDecoder.decode(Weather.self, from: data)
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
			},
			fetchWeather: {
				Weather(
					units: Weather.Unit(
						temperature: "°K"
					),
					current: Weather.Current(
						temperature: 34
					)
				)
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
			},
			fetchWeather: {
				Weather(
					units: Weather.Unit(
						temperature: "°K"
					),
					current: Weather.Current(
						temperature: 34
					)
				)
			}
		)
	}
}
