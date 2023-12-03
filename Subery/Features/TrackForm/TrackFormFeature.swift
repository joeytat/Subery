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
    @BindingState var name: String
    @BindingState var category: String
    @BindingState var price: String
    @BindingState var startAtDate: Date
    @BindingState var endAtDate: Date
    @BindingState var renewalFrequency: Track.RenewalFrequency = .monthly
    @BindingState var currency: Currency = .current

    var placeholderService: TrackPreset = TrackPreset.popularPresets.randomElement()!
    var serviceSuggestions: IdentifiedArrayOf<TrackPreset> = []

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
        if state.name.isEmpty {
          state.serviceNameError = "Service name is required"
          return .none
        }

        if state.category.isEmpty {
          state.serviceCategoryError = "Service category is required"
          return .none
        }

        if state.price.isEmpty {
          state.servicePriceError = "Service price is required"
          return .none
        }

        if let price = Float(state.price.filter { $0.isNumber }),
           price <= 0 {
          state.servicePriceError = "Service price should be greater than 0"
          return .none
        }

        if state.startAtDate > state.endAtDate {
          state.serviceEndAtError = "Service end date should be after start date"
          return .none
        }

        return .run { [state] send in
          await send(
            .delegate(
              .saveTrack(
                .init(
                  id: self.uuid(),
                  name: state.name,
                  category: state.category,
                  price: state.price,
                  startAtDate: state.startAtDate,
                  endAtDate: state.endAtDate
                )
              )
            )
          )
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
