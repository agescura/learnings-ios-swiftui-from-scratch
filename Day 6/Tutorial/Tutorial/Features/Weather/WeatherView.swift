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

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

		private let locationManager = CLLocationManager()
		@Published var locationStatus: CLAuthorizationStatus?
		@Published var lastLocation: CLLocation?

		override init() {
				super.init()
				locationManager.delegate = self
				locationManager.desiredAccuracy = kCLLocationAccuracyBest
				locationManager.requestWhenInUseAuthorization()
				locationManager.startUpdatingLocation()
		}

	 
		
		var statusString: String {
				guard let status = locationStatus else {
						return "unknown"
				}
				
				switch status {
				case .notDetermined: return "notDetermined"
				case .authorizedWhenInUse: return "authorizedWhenInUse"
				case .authorizedAlways: return "authorizedAlways"
				case .restricted: return "restricted"
				case .denied: return "denied"
				default: return "unknown"
				}
		}

		func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
				locationStatus = status
				print(#function, statusString)
			locationManager.requestWhenInUseAuthorization()
		}
		
		func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
				guard let location = locations.last else { return }
				lastLocation = location
				print(#function, location)
		}
}

@Observable
class WeatherModel: NSObject {
	
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
	let locationManager: CLLocationManager
	
	override init() {
		self.locationManager = CLLocationManager()
		super.init()
		self.locationManager.delegate = self
	}
	
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
	
	func requestLocation() {
		locationManager.requestAlwaysAuthorization()
		locationManager.startUpdatingLocation()
	}
}

extension WeatherModel: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print(locations[0])
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
	print("error: \(error.localizedDescription)")
	}
}

struct WeatherView: View {
	let model: WeatherModel
	@StateObject var locationManager = LocationManager()
	
	var body: some View {
		ZStack {
			VStack {
				Button("Request location") {
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
