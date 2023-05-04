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
    var isTrackSheetPresented: Bool = false

    @BindingState var serviceName: String = ""
    @BindingState var servicePrice: String = ""
    enum RenewalFrequency {
      case yearly
      case quartly
      case monthly
    }
    var serviceRenewalFrequency: RenewalFrequency?
    var serviceStartAt: Date?
    var serviceEndAt: Date?

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
      case .landingControlButtonTapped:
        state.isLandingActive = false
        state.isTrackSheetPresented = true
        return .none
      case .setTrackSheetPresented(let isPresented):
        state.isTrackSheetPresented = isPresented
        return .none
      case .binding(\.$servicePrice):
        let numberStr = state.servicePrice.filter { $0.isNumber }
        if let deformattedPriceValue = Float(numberStr) {
          state.servicePrice = deformattedPriceValue.formatted()
        } else {
          state.servicePrice = Float(state.servicePrice)?.formatted() ?? ""
        }
        return .none
      case .binding:
        return .none
      }
    }._printChanges()
  }
}
