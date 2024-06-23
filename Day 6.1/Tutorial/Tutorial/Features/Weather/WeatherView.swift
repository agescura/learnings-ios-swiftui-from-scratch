import SwiftUI
import Dependencies

import CoreLocation

/*
 Si no tenemos internet, mostrar info de que no hay internet
 Si no tenemos internet, deshabilitar botones que afecten a internet, boton de reintentar llamada.
 
 Obtener la localizacion del dispositivo
	preguntar al usuario
	
 user dice que no -> oye no puedo obtener la loc, tienes que ir a settings para seguir, para etc.... boton a settings
 
 user dice que si -> pillamos la loc, y llamamos a internet y mostramos el resultado
 */

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
	
	@ObservationIgnored
	@Dependency(\.locationClient) var locationClient
	
	func onAppear() {
		Task {
			for await delegate in try await self.locationClient.delegate() {
				print(delegate)
				switch delegate {
						
					case .didChangeAuthorization(.authorizedWhenInUse), 
							.didChangeAuthorization(.authorizedAlways):
						self.locationClient.start()
						
					case .didChangeAuthorization:
						break
					case .didUpdateLocations:
						break
					case .didFailWithError:
						break
				}
			}
		}
		
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
		
		Task {
			await self.locationClient.requestLocation()
		}
	}
	
	func requestLocation() {
		self.locationClient.start()
	}
}

struct WeatherView: View {
	let model: WeatherModel
	
	var body: some View {
		ZStack {
			VStack {
				Button("Location") {
					self.model.requestLocation()
				}
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
					VStack(
						alignment: .leading,
						spacing: 8
					) {
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

func foo() -> String {
	[1, 2, 3, 4, 5, 6]
		.map { "\($0)" }
		// ["1", "2", "3", ....]
		.reduce("") { $0 + $1 }
		
		// "123456"
}
