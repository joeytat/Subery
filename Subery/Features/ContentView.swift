//
//  ContentView.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store: StoreOf<ListFeature>

  var body: some View {
    NavigationStack {
      WithViewStore(store, observe: { $0 }) { viewStore in
        GradientBackgroundView().overlay {
          ListView(store: store)
        }
      }
    }
    .preferredColorScheme(.light)
  }
}
