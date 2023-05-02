//
//  SuberyApp.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI
import ComposableArchitecture

@main
struct SuberyApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(
          initialState: AppState.State(),
          reducer: AppState()
        )
      )
    }
  }
}
