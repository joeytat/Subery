//
//  LinearBackgroundView.swift
//  Subery
//
//  Created by yu wang on 2023/5/2.
//

import SwiftUI

struct GradientBackgroundView: View {
  var body: some View {
    LinearGradient(
      gradient: Gradient(colors: [Color.black, Color.accentColor]),
      startPoint: .bottomLeading,
      endPoint: .topTrailing
    )
    .ignoresSafeArea()
  }
}

struct LinearBackgroundView_Previews: PreviewProvider {
  static var previews: some View {
    GradientBackgroundView()
  }
}

