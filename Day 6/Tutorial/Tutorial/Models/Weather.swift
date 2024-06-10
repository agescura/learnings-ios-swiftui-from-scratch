import Foundation

struct Weather: Decodable {
	var units: Unit
	var current: Current
	
	struct Unit: Decodable {
		var temperature: String
		
		enum CodingKeys: String, CodingKey {
			case temperature = "temperature_2m"
		}
	}
	
	struct Current: Decodable {
		var temperature: Double
//		var time: Date
		
		enum CodingKeys: String, CodingKey {
			case temperature = "temperature_2m"
		}
	}
	
	enum CodingKeys: String, CodingKey {
		case units = "current_units", current
	}
}
