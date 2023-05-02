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
    NavigationView {
      ZStack {
        LinearBackgroundView()
        LandingView(store: store)
      }
    }
  }
}

struct LinearBackgroundView: View {
  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color.black, Color.accentColor]),
        startPoint: .bottomLeading,
        endPoint: .topTrailing
      )
      .edgesIgnoringSafeArea(.all)
    }
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

