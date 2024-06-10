import Dependencies
import Network
import Combine
import Foundation

extension DependencyValues {
	var reachabilityClient: ReachabilityClient {
		get { self[ReachabilityClient.self] }
		set { self[ReachabilityClient.self] = newValue }
	}
}

struct ReachabilityClient {
	var start: () -> AsyncStream<Bool>
	var cancel: () -> Void
}

extension ReachabilityClient: DependencyKey {
	static var liveValue: ReachabilityClient {
		var monitor: NetworkMonitor?
		
		return ReachabilityClient(
			start: {
				monitor = NetworkMonitor()
				
				return AsyncStream { continuation in
					let cancellable = monitor?.networkStatus.sink { continuation.yield($0) }
					continuation.onTermination = { _ in
						cancellable?.cancel()
					}
				}
			},
			cancel: { monitor?.cancel() }
		)
	}
}

extension ReachabilityClient: TestDependencyKey {
	static var previewValue: ReachabilityClient {
		var cancellable: AnyCancellable?
		return ReachabilityClient(
			start: {
				AsyncStream { continuation in
					cancellable = Timer.publish(every: 2, on: .main, in: .default)
						.autoconnect()
						.scan(.satisfied) { status, _ in
							status == .satisfied ? .unsatisfied : .satisfied
						}
						.map { $0 == .satisfied ? true : false }
						.sink { continuation.yield($0) }
					cancellable = nil
				}
			},
			cancel: {}
		)
	}
}

final class NetworkMonitor {
	private let pathMonitor = NWPathMonitor()
	private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
	
	let networkStatus = PassthroughSubject<Bool, Never>()
	
	init() {
		pathMonitor.pathUpdateHandler = { [weak self] path in
			guard let self else { return }
			
			networkStatus.send(path.status == .satisfied)
		}
		
		pathMonitor.start(queue: monitorQueue)
	}
	
	func cancel() {
		pathMonitor.cancel()
	}
}
