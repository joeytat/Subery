//
//  ContentView.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store: StoreOf<TracksFeature>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GradientBackgroundView().overlay {
        TracksView(store: store)
      }
    }
    .preferredColorScheme(.light)
  }
}
