//
//  GradientNoiseBackground.swift
//  Subery
//
//  Created by yu wang on 2023/5/2.
//

import Foundation
import SwiftUI

struct GradientNoiseBackground: View {
  let noiseSize: CGFloat = 4
  let noiseSpacing: CGFloat = 35

  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color.black, Color.accentColor]),
        startPoint: .bottomLeading,
        endPoint: .topTrailing
      )
      .ignoresSafeArea()

      GeometryReader { geometry in
        ForEach(0..<Int(geometry.size.width / noiseSpacing), id: \.self) { x in
          ForEach(0..<Int(geometry.size.height / noiseSpacing), id: \.self) { y in
            NoiseRectangle(delay: Double(y) * 0.05)
              .frame(width: noiseSize, height: noiseSize)
              .position(x: CGFloat(x) * noiseSpacing, y: CGFloat(y) * noiseSpacing)
          }
          .ignoresSafeArea()
        }
        .ignoresSafeArea()
      }
    }
  }
}

struct NoiseRectangle: View {
  let delay: Double
  @State private var opacity: Double = 0

  var body: some View {
    Rectangle()
      .fill(Color.gray.opacity(opacity))
      .onAppear {
        withAnimation(Animation.linear(duration: 2)
          .repeatForever(autoreverses: true)
          .delay(delay)) {
            opacity = 0.15
          }
      }
  }
}

struct GradientNoiseBackground_Previews: PreviewProvider {
  static var previews: some View {
    GradientNoiseBackground()
  }
}

