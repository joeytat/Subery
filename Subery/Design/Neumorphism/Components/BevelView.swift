import SwiftUI

struct BevelViewModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding()
      .background(
        ZStack {
          Capsule()
            .fill(Color.neumorphism.element)
            .northWestShadow(radius: 3, offset: 1)
          Capsule()
            .inset(by: 3)
            .fill(Color.neumorphism.element)
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
      Color.neumorphism.element
      Text("preview.content").bevelStyle()
    }
    .previewLayout(.sizeThatFits)
  }
}
