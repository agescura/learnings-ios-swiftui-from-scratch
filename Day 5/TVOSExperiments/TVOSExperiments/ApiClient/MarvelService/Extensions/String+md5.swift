import Foundation
import CryptoKit

extension String {
  var md5: String {
    Insecure
      .MD5
      .hash(data: Data(self.utf8))
      .map { String(format: "%02hhx", $0) }
      .joined()
  }
}
