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
    // Landing
    var isLandingActive: Bool = true
    // TrackView
    @BindingState var serviceName: String = ""
    var isTrackSheetPresented: Bool = false
  }

  enum Action: BindableAction, Equatable {
    case landingControlButtonTapped
    case binding(BindingAction<State>)
    case setTrackSheetPresented(isPresented: Bool)
  }

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .landingControlButtonTapped:
        state.isLandingActive = false
        state.isTrackSheetPresented = true
        return .none
      case .setTrackSheetPresented(let isPresented):
        state.isTrackSheetPresented = isPresented
        return .none
      }
    }._printChanges()
  }
}
