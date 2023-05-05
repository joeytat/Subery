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
    // Track
    @BindingState var serviceName: String = ""
    @BindingState var servicePrice: String = ""
    enum RenewalFrequency {
      case yearly
      case quartly
      case monthly
    }
    var serviceRenewalFrequency: RenewalFrequency?
    @BindingState var serviceStartAt: String = ""
    @BindingState var serviceStartAtDate: Date = Date()
    @BindingState var isServiceDateStartPickerPresented: Bool = false

    @BindingState var serviceEndAt: String = ""
    @BindingState var serviceEndAtDate: Date = Date()
    @BindingState var isServiceDateEndPickerPresented: Bool = false
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
  }

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.$isServiceDateStartPickerPresented):
        if !state.isServiceDateStartPickerPresented {
          state.serviceStartAt = state.serviceStartAtDate.startOfDay().format()
        }
        return .none
      case .binding(\.$isServiceDateEndPickerPresented):
        if !state.isServiceDateEndPickerPresented {
          state.serviceEndAt = state.serviceEndAtDate.startOfDay().format()
        }
        return .none
      case .binding(\.$serviceStartAtDate):
        state.serviceStartAt = state.serviceStartAtDate.startOfDay().format()
        return .none
      case .binding(\.$serviceEndAtDate):
        state.serviceEndAt = state.serviceEndAtDate.startOfDay().format()
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
