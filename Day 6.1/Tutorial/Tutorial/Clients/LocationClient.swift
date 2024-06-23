import Foundation
import Dependencies
import CoreLocation

extension DependencyValues {
	var locationClient: LocationClient {
		get { self[LocationClient.self] }
		set { self[LocationClient.self] = newValue }
	}
}

struct LocationClient {
	var locationStatus: () async -> CLAuthorizationStatus
	var requestLocation: () async -> Void
	var start: () -> Void
	var delegate: () async throws -> AsyncStream<LocationManager.Delegate>
}

extension LocationClient: DependencyKey {
	static var liveValue: Self {
		let manager = LocationManager()
		manager.manager.delegate = manager
		
		return Self(
			locationStatus: { manager.authorizationStatus() },
			requestLocation: { manager.requestWhenInUseAuthorization() },
			start: {
				manager.start()
			},
			delegate: {
				AsyncStream<LocationManager.Delegate> {  continuation in
					continuation.yield(with: .success(.didChangeAuthorization(.notDetermined)))
				}
			}
		)
	}
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
	let manager: CLLocationManager
	
	enum Delegate {
		case didChangeAuthorization(CLAuthorizationStatus)
		case didUpdateLocations([CLLocation])
		case didFailWithError(Error)
	}
	
	init(
		manager: CLLocationManager = CLLocationManager()
	) {
		self.manager = manager
	}
	
	func authorizationStatus() -> CLAuthorizationStatus {
		self.manager.authorizationStatus
	}
	
	func requestWhenInUseAuthorization() -> Void {
		self.manager.requestWhenInUseAuthorization()
	}
	
	func start() {
		self.manager.startUpdatingLocation()
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		print(manager.authorizationStatus)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		print(locations)
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
		print(error)
	}
}

extension LocationClient: TestDependencyKey {
	static var previewValue: Self {
		Self(
			locationStatus: { .notDetermined },
			requestLocation: {},
			start: {},
			delegate: { .finished }
		)
	}
}

extension	LocationClient {
	static var testValue: Self {
		Self(
			locationStatus: { .notDetermined },
			requestLocation: {},
			start: {},
			delegate: { .finished }
		)
	}
}
