//
//  SuberyApp.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI
import ComposableArchitecture
@main
struct Subery: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        TracksListView(
          store: Store(
            initialState: TracksListFeature.State()
          ) {
            TracksListFeature()
          }
        )
      }
    }
  }
}
