import SwiftUI
import Dependencies

enum State: Equatable, Hashable {
	case idle
	case isLoading
	case loaded([Country])
	case error(ApiError)
}


@Observable
class CountryModel: Equatable, Hashable {
	static func == (lhs: CountryModel, rhs: CountryModel) -> Bool {
		lhs === rhs
	}
	func hash(into hasher: inout Hasher) {
		hasher.combine(state)
	}
	
	@ObservationIgnored 
	@Dependency(\.apiClient) var apiClient
	var state: State
	var countrySelected: Country?
	
	init(
		state: State = .idle,
		countrySelected: Country? = nil
	) {
		self.state = state
		self.countrySelected = countrySelected
	}
	
	func fetchCountries() {
		self.state = .isLoading
		Task {
			do {
				self.state = try await .loaded(self.apiClient.fetchCountries())
			} catch {
				self.state = .error(.unknown)
			}
		}
	}
	
	func selectButtonTapped(country countrySelected: Country) {
		self.countrySelected = self.countrySelected == countrySelected
		? nil
		: countrySelected
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
								.contentShape(Rectangle())
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
			model: CountryModel()
		)
		.navigationTitle("Countries")
	}
}
