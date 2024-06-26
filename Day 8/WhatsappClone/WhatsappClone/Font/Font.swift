import Foundation
import UIKit

public enum LatoFonts: String, CaseIterable {
	case italic = "Lato-Italic"
	case lightItalic = "Lato-LightItalic"
	case thin = "Lato-Thin"
	case bold = "Lato-Bold"
	case black = "Lato-Black"
	case regular = "Lato-Regular"
	case blackItalic = "Lato-BlackItalic"
	case boldItalic = "Lato-BoldItalic"
	case light = "Lato-Light"
	case thinItalic = "Lato-ThinItalic"
}

public func registerFonts() {
	for font in LatoFonts.allCases {
		_ = UIFont.registerFont(bundle: .main, fontName: font.rawValue, fontExtension: "ttf")
	}
}

extension UIFont {
	static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) -> Bool {
		guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
			fatalError("Couldn't find font \(fontName)")
		}
		
		guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
			fatalError("Couldn't load data from the font \(fontName)")
		}
		
		guard let font = CGFont(fontDataProvider) else {
			fatalError("Couldn't create font from data")
		}
		
		var error: Unmanaged<CFError>?
		let success = CTFontManagerRegisterGraphicsFont(font, &error)
		guard success else {
			print("Error registering font: maybe it was already registered.")
			return false
		}
		
		return true
	}
}
