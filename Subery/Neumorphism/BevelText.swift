import SwiftUI

struct BevelViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .background(
        ZStack {
          Capsule()
            .fill(Color.element)
            .northWestShadow(radius: 3, offset: 1)
          Capsule()
            .inset(by: 3)
            .fill(Color.element)
            .southEastShadow(radius: 1, offset: 1)
        }
      )
  }
}

extension View {
  func bevelStyle() -> some View {
    self.modifier(BevelViewModifier())
  }
}

struct BevelText_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.element
      Text("Test").bevelStyle()
    }
    .previewLayout(.sizeThatFits)
  }
}
