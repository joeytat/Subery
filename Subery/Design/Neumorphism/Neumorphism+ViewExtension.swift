import SwiftUI

extension View {
  /// Light shadow on the northwest edge, dark shadow on the southeast edge.
  ///   - parameters:
  ///     - radius: The size of the shadow
  ///     - offset: The value used for (-x, -y) and (x, y) offsets
  func northWestShadow(
    radius: CGFloat = 8,
    offset: CGFloat = 4
  ) -> some View {
    return self
      .shadow(
        color: Color.neumorphism.highlight,
        radius: radius,
        x: -offset,
        y: -offset)
      .shadow(
        color: Color.neumorphism.shadow, radius: radius, x: offset, y: offset)
  }

  /// Simulate shining a light on the southeast edge of a view.
  /// Light shadow on the southeast edge, dark shadow on the northwest edge.
  ///   - parameters:
  ///     - radius: The size of the shadow
  ///     - offset: The value used for (-x, -y) and (x, y) offsets
  func southEastShadow(
    radius: CGFloat = 8,
    offset: CGFloat = 4
  ) -> some View {
    return self
      .shadow(
        color: Color.neumorphism.shadow, radius: radius, x: -offset, y: -offset)
      .shadow(
        color: Color.neumorphism.highlight, radius: radius, x: offset, y: offset)
  }
}
