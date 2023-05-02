//
//  ContentView.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
  let store: StoreOf<AppState>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      LandingView(store: store)
    }
    .background(GradientBackgroundView())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      store: Store(
        initialState: AppState.State(isLandingActive: true),
        reducer: AppState()
      )
    )
  }
}
