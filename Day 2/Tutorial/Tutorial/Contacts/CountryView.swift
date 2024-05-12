import SwiftUI

enum State {
	case idle
	case isLoading
	case loaded([Country])
	case error(Error)
}

@Observable
class CountryModel {
	let apiClient: ApiClient
	var state: State
	var countrySelected: Country?
	
	init(
		apiClient: ApiClient = .mock,
		state: State = .idle,
		countrySelected: Country? = nil
	) {
		self.apiClient = apiClient
		self.state = state
		self.countrySelected = countrySelected
	}
	
	func fetchCountries() {
		self.state = .isLoading
		Task {
			do {
				self.state = try await .loaded(self.apiClient.fetchCountries())
			} catch {
				self.state = .error(error)
			}
		}
	}
	
	func selectButtonTapped(country countrySelected: Country) {
		self.countrySelected = countrySelected
	}
}

struct CountryView: View {
	let model: CountryModel
	
	var body: some View {
		VStack {
			switch self.model.state {
				case .idle:
					EmptyView()
				case .isLoading:
					ProgressView()
				case let .loaded(countries):
					List {
						ForEach(countries) { country in
							Button {
								self.model.selectButtonTapped(country: country)
							} label: {
								HStack {
									VStack(alignment: .leading) {
										Text(country.name.common)
											.font(.title3)
										Text(country.name.official)
											.font(.caption)
									}
									Spacer()
									if country == self.model.countrySelected {
										Image(systemName: "checkmark")
									}
								}
							}
							.buttonStyle(.plain)
						}
					}
				case .error(let error):
					Text(error.localizedDescription)
			}
		}
		.onAppear {
			self.model.fetchCountries()
		}
	}
}

#Preview {
	NavigationStack {
		CountryView(
			model: CountryModel(
				apiClient: .mock
			)
		)
		.navigationTitle("Countries")
	}
}

/*
 onAppear
 antes de hacer la llamada
 mientras dure la llamada => loader, progress .. o lo que sea
 
 despues de hacer la llamada => si ha ido bien o mal
 
 hay que usar hilos para no bloquear la pantalla
 en background se hara la llamada
 
  Void () -> [Country]
 func fetchCountries(continent: .europe) -> [Country] {
		???????
 }
 
 class A {
	let b = ClassB()
 }
 
 class A {
 let b: ClassB?
 
 func(b: ClassB) { self.b = b }
 }
 */

struct ApiClient {
	var fetchCountries: () async throws -> [Country]
}

enum ApiError: Error {
	case unknown
}

extension ApiClient {
	static var live: ApiClient {
		
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

extension ApiClient {
	static var mock: ApiClient {
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
	static var error: ApiClient {
		return ApiClient(
			fetchCountries: {
				try await Task.sleep(for: .seconds(1))
				throw ApiError.unknown
			}
		)
	}
}

struct Country: Identifiable, Decodable, Equatable {
	let flags: Flags
	let name: Name
	
	struct Name: Decodable, Equatable {
		let common: String
		let official: String
	}
	
	struct Flags: Decodable, Equatable {
		let png: String
	}
	
	var id: String {
		self.name.official
	}
}
