//
//  AddTrackFeature.swift
//  Subery
//
//  Created by yu wang on 2023/5/1.
//

import Foundation
import ComposableArchitecture

struct TrackFormFeature: Reducer {
  struct State: Equatable {
    var placeholderService: TrackPreset = TrackPreset.popularPresets.randomElement()!
    var serviceSuggestions: IdentifiedArrayOf<TrackPreset> = []

    @BindingState var track: Track
    @BindingState var focus: Field?

    var serviceNameError: String?
    var serviceCategoryError: String?
    var servicePriceError: String?
    var serviceStartAtError: String?
    var serviceEndAtError: String?

    var isServiceDateStartPickerPresented: Bool = false
    var isServiceDateEndPickerPresented: Bool = false

    @BindingState var priceDescription: String = ""

    enum Field: Hashable {
      case name
      case category
      case price
      case startAt
      case endAt
    }
  }

  enum Action: BindableAction {
    enum Delegate {
      case saveTrack(Track)
    }
    case delegate(Delegate)
    case binding(BindingAction<State>)
    case onCancelButtonTapped
    case onSaveButtonTapped
    case setServiceDateStartPickerPresented(isPresented: Bool)
    case setServiceDateEndPickerPresented(isPresented: Bool)
  }

  @Dependency(\.dismiss) var dismiss
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .onSaveButtonTapped:
        if state.track.name.isEmpty {
          state.serviceNameError = "Service name is required"
          return .none
        }

        if state.track.category.isEmpty {
          state.serviceCategoryError = "Service category is required"
          return .none
        }

        if state.track.price.isEmpty {
          state.servicePriceError = "Service price is required"
          return .none
        }

        if let price = Float(state.track.price.filter { $0.isNumber }), price <= 0 {
          state.servicePriceError = "Service price should be greater than 0"
          return .none
        }

        if state.track.startAtDate > state.track.endAtDate {
          state.serviceEndAtError = "Service end date should be after start date"
          return .none
        }
        return .run { [ track = state.track] send in
          await send(.delegate(.saveTrack(track)))
          await self.dismiss()
        }
      case .onCancelButtonTapped:
        return .run { _ in await self.dismiss() }
      case .binding:
        return .none
      case .delegate:
        return .none
      case .setServiceDateStartPickerPresented(let isPresented):
        state.isServiceDateStartPickerPresented = isPresented
        return .none
      case .setServiceDateEndPickerPresented(let isPresented):
        state.isServiceDateEndPickerPresented = isPresented
        return .none
      }
    }._printChanges()
  }
}
