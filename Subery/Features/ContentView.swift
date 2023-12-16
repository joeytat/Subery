//
//  ContentView.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store: StoreOf<TracksListFeature>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      GradientBackgroundView().overlay {
        NavigationStack {
          TracksListView(store: store)
        }
      }
    }
    .preferredColorScheme(.light)
  }
}
