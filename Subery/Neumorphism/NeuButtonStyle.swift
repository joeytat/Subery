import SwiftUI

struct NeuButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration)
  -> some View {
    configuration.label
      .opacity(configuration.isPressed ? 0.2 : 1)
      .padding()
      .background(
        Group {
          if configuration.isPressed {
            Capsule()
              .fill(Color.element)
              .southEastShadow()
          } else {
            Capsule()
              .fill(Color.element)
              .northWestShadow()
          }
        }
      )
  }
}
