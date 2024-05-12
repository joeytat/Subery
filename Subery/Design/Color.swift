import Foundation
import SwiftUI

extension Color {
    /// Create a Color view from an RGB object.
    ///   - parameters:
    ///     - rgb: The RGB object.
    init(rgbStruct rgb: RGB) {
        self.init(red: rgb.red, green: rgb.green, blue: rgb.blue)
    }

}

extension Color {
    struct Neumorphism {
        let element = Color("Element")
        let highlight = Color("Highlight")
        let shadow = Color("Shadow")
    }

    static let neumorphism = Neumorphism()
}

extension Color {
    struct Daisy {
        let primary = Color("primary")
        let primaryFocus = Color("primary-focus")
        let primaryContent = Color("primary-content")

        let secondary = Color("secondary")
        let secondaryFocus = Color("secondary-focus")
        let secondaryContent = Color("secondary-content")

        let accent = Color("accent")
        let accentFocus = Color("accent-focus")
        let accentContent = Color("accent-content")
        let accentInvert = Color("accent-invert")

        let neutral = Color("neutral")
        let neutralFocus = Color("neutral-focus")
        let neutralContent = Color("neutral-content")

        let info = Color("info")
        let infoContent = Color("info-content")
        let error = Color("error")
        let errorContent = Color("error-content")
        let success = Color("success")
        let successContent = Color("success-content")
        let warning = Color("warning")
        let warningContent = Color("warning-content")
    }

    static let daisy = Daisy()
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

struct Colors_Previews: PreviewProvider {

    static var previews: some View {
        Color.daisy.neutral.overlay {
            VStack(alignment: .leading, spacing: Theme.spacing.lg) {
                HStack {
                    Text("Primary")
                        .foregroundStyle(Color.daisy.primaryContent)
                        .padding()
                        .background(Color.daisy.primary)
                        .cornerRadius(Theme.spacing.sm)

                    Text("Secondary")
                        .foregroundStyle(Color.daisy.secondaryContent)
                        .padding()
                        .background(Color.daisy.secondary)
                        .cornerRadius(Theme.spacing.sm)

                }

                HStack {
                    Text("Accent")
                        .foregroundStyle(Color.daisy.accentContent)
                        .padding()
                        .background(Color.daisy.accent)
                        .cornerRadius(Theme.spacing.sm)

                    Text("Info")
                        .foregroundStyle(Color.daisy.infoContent)
                        .padding()
                        .background(Color.daisy.info)
                        .cornerRadius(Theme.spacing.sm)
                }

                HStack {
                    Text("Secondary")
                        .foregroundStyle(Color.daisy.errorContent)
                        .padding()
                        .background(Color.daisy.error)
                        .cornerRadius(Theme.spacing.sm)

                    Text("Success")
                        .foregroundStyle(Color.daisy.successContent)
                        .padding()
                        .background(Color.daisy.success)
                        .cornerRadius(Theme.spacing.sm)

                    Text("Warning")
                        .foregroundStyle(Color.daisy.warningContent)
                        .padding()
                        .background(Color.daisy.warning)
                        .cornerRadius(Theme.spacing.sm)
                }

                Text("Focus")
                    .foregroundStyle(Color.daisy.neutralContent)
                    .padding()
                    .cornerRadius(Theme.spacing.sm)

                HStack {
                    Text("Primary")
                        .foregroundStyle(Color.daisy.primaryContent)
                        .padding()
                        .background(Color.daisy.primaryFocus)
                        .cornerRadius(Theme.spacing.sm)

                    Text("Secondary")
                        .foregroundStyle(Color.daisy.secondaryContent)
                        .padding()
                        .background(Color.daisy.secondaryFocus)
                        .cornerRadius(Theme.spacing.sm)

                }

                HStack {
                    Text("Accent")
                        .foregroundStyle(Color.daisy.accentContent)
                        .padding()
                        .background(Color.daisy.accentFocus)
                        .cornerRadius(Theme.spacing.sm)

                    Text("Info")
                        .foregroundStyle(Color.daisy.infoContent)
                        .padding()
                        .background(Color.daisy.info)
                        .cornerRadius(Theme.spacing.sm)
                }

                HStack {
                    Text("Secondary")
                        .foregroundStyle(Color.daisy.errorContent)
                        .padding()
                        .background(Color.daisy.error)
                        .cornerRadius(Theme.spacing.sm)

                    Text("Success")
                        .foregroundStyle(Color.daisy.successContent)
                        .padding()
                        .background(Color.daisy.success)
                        .cornerRadius(Theme.spacing.sm)

                    Text("Warning")
                        .foregroundStyle(Color.daisy.warningContent)
                        .padding()
                        .background(Color.daisy.warning)
                        .cornerRadius(Theme.spacing.sm)
                }
            }
            .padding()
        }
        .ignoresSafeArea()

    }
}
