import Foundation

enum Marvel {
  case characters(Int)
  case uri(Int, URIType)
  
  enum URIType: String {
    case comics, series, events
  }
}
