import SwiftUI
import Dependencies

@Observable
class WeatherModel {
	
	enum State: Equatable {
		case idle
		case loading
		case loaded(String)
		case error(WeatherError)
		
		enum WeatherError: Equatable {
			case apiError
		}
	}
	enum Reachability {
		case internet, noInternet
	}
	
	var state: State = .idle
	var reachability: Reachability = .noInternet
	
	@ObservationIgnored
	@Dependency(\.apiClient) var apiClient
	
	@ObservationIgnored
	@Dependency(\.reachabilityClient) var reachabilityClient
	
	func onAppear() {
		Task {
			for await reach in self.reachabilityClient.start() {
				self.reachability = reach == true ? .internet : .noInternet
			}
		}
		
		Task {
			do {
				let weather = try await self.apiClient.fetchWeather()
				self.state = .loaded("\(weather.current.temperature) \(weather.units.temperature)")
			} catch {
				self.state = .error(.apiError)
			}
		}
	}
	//
}

struct WeatherView: View {
	let model: WeatherModel
	
	var body: some View {
		ZStack {
			VStack {
				switch self.model.state {
					case .idle, .loading:
						ProgressView()
					case let .loaded(temperature):
						Text(temperature)
							.font(.title2)
					case .error:
						EmptyView()
				}
			}
			if self.model.reachability == .noInternet {
				VStack {
					Spacer()
					VStack {
						Text("No tienes internet.")
							.font(.title2)
							.foregroundColor(.black)
						Button("Reintentar") {
							
						}
						.buttonStyle(.borderedProminent)
						.tint(.black)
					}
					.padding()
					.background(Color.red)
					.cornerRadius(16)
				}
			}
		}
		.onAppear {
			self.model.onAppear()
		}
	}
}

#Preview {
	WeatherView(
		model: WeatherModel()
	)
}



class User2 {
	let name: String
	let create: Date
	
	init(
		name: String
	) {
		self.name = name
		@Dependency(\.date.now) var now
		self.create = now
	}
}


extension User2 {
	static let mock = User2(name: "Albert")
}
