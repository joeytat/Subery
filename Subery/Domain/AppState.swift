//
//  Feature.swift
//  Subery
//
//  Created by yu wang on 2023/5/1.
//

import Foundation
import ComposableArchitecture

struct AppState: ReducerProtocol {

  struct State: Equatable {
    var isLandingActive: Bool = true
  }

  enum Action: Equatable {
    case landingControlButtonTapped
  }

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .landingControlButtonTapped:
      state.isLandingActive = false
      return .none
    }
  }
}
