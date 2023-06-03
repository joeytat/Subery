import SwiftUI

struct ColorCircle: View {
  let rgb: RGB
  let size: CGFloat

  var body: some View {
    ZStack {
      Circle()
        .fill(Color.neumorphism.element)
        .northWestShadow()
    }
    .frame(width: size, height: size)
  }
}

struct ColorCircle_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.neumorphism.element
      ColorCircle(rgb: RGB(), size: 200)
    }
    .frame(width: 300, height: 300)
    .previewLayout(.sizeThatFits)
  }
}
