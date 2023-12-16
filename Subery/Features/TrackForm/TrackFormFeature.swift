//
//  AddTrackFeature.swift
//  Subery
//
//  Created by yu wang on 2023/5/1.
//

import Foundation
import ComposableArchitecture

struct TrackFormFeature: Reducer {
  @Dependency(\.uuid) var uuid
  @Dependency(\.date) var date

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
    case setServiceDateStartPickerPresented(isPresented: Bool)
    case setServiceDateEndPickerPresented(isPresented: Bool)
  }

  @Dependency(\.dismiss) var dismiss
  var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
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
