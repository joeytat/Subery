import Foundation
import SwiftUI

extension Color {
  /// Create a Color view from an RGB object.
  ///   - parameters:
  ///     - rgb: The RGB object.
  init(rgbStruct rgb: RGB) {
    self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
  }

  // Add Neumorphism colors to standard colors
  static let element = Color("Element")
  static let highlight = Color("Highlight")
  static let shadow = Color("Shadow")
  static let lightGray = Color("LightGray")
  static let dark = Color("Dark")
  static let theme = Color("Theme")
}

extension Color {
  static func color(from hex: String) -> Color {
    var hex = hex
    if hex.hasPrefix("#") {
      hex.removeFirst()
    }

    if hex.count == 3 {
      var tripledHex = ""
      for char in hex {
        tripledHex += String(char) + String(char)
      }
      hex = tripledHex
    }

    let scanner = Scanner(string: hex)
    var rgb: UInt64 = 0
    scanner.scanHexInt64(&rgb)

    let r = Double((rgb & 0xFF0000) >> 16) / 255.0
    let g = Double((rgb & 0x00FF00) >> 8) / 255.0
    let b = Double(rgb & 0x0000FF) / 255.0

    return Color(red: r, green: g, blue: b)
  }
}
