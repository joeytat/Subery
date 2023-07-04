//
//  AddTrackFeature.swift
//  Subery
//
//  Created by yu wang on 2023/5/1.
//

import Foundation
import ComposableArchitecture

struct AddTrackFeature: ReducerProtocol {
  struct State: Equatable {
    var placeholderService: SubscriptionServicePreset = State.popularSubscriptions.randomElement()!
    var serviceSuggestions: IdentifiedArrayOf<SubscriptionServicePreset> = []
    var track: Track

    var serviceNameError: String?
    var serviceCategoryError: String?
    var servicePriceError: String?
    var serviceStartAtError: String?
    var serviceEndAtError: String?

    @BindingState var servicePricePerMonth: String = ""
    @BindingState var isServiceDateStartPickerPresented: Bool = false
    @BindingState var isServiceDateEndPickerPresented: Bool = false
    @BindingState var serviceFocusedInput: AddTrackView.FormInput?
  }

  enum Action: BindableAction {
    enum Delegate {
      case saveTrack(Track)
    }
    case delegate(Delegate)
    case binding(BindingAction<State>)
    case onCancelButtonTapped
    case onSaveButtonTapped
    case setName(String)
    case setCategory(String)
    case setPrice(String)
    case setCurrency(Currency)
    case setStartAt(Date)
    case setEndAt(Date)
    case setRenewalFrequency(Track.RenewalFrequency)
  }

  @Dependency(\.dismiss) var dismiss
  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .setName(let name):
        state.track.name = name
        if !name.isEmpty {
          let suggestionsResult: IdentifiedArrayOf<AddTrackFeature.State.SubscriptionServicePreset> = IdentifiedArray(
            uniqueElements: State.popularSubscriptions
              .filter { $0.name.lowercased().starts(with: name.lowercased()) }
          )
          if suggestionsResult.count == 1,
             let firstPreset = suggestionsResult.first,
             firstPreset.name == name {
            state.serviceSuggestions = []
            state.track.category = firstPreset.category.rawValue
          } else {
            state.serviceSuggestions = suggestionsResult
          }
          state.serviceNameError = nil
        } else {
          state.serviceSuggestions = []
        }
        return .none
      case .setCategory(let category):
        state.track.category = category
        return .none
      case .setStartAt(let date):
        state.track.startAtDate = date
        return .none
      case .setEndAt(let date):
        state.track.endAtDate = date
        return .none
      case .setCurrency(let currency):
        state.track.currency = currency
        return .none
      case .setPrice(let priceStr):
        let numberStr = priceStr.filter { $0.isNumber }
        if let deformattedPriceValue = Float(numberStr)?.roundedToDecimalPlaces(), deformattedPriceValue > 0 {
          state.track.price = deformattedPriceValue.formatted()
          switch state.track.renewalFrequency {
          case .monthly:
            state.servicePricePerMonth = ""
          case .quarterly:
            state.servicePricePerMonth = "\((deformattedPriceValue / 4).roundedToDecimalPlaces())/month"
          case .yearly:
            state.servicePricePerMonth = "\((deformattedPriceValue / 12).roundedToDecimalPlaces())/month"
          }
          state.servicePriceError = nil
        }
        return .none
      case .setRenewalFrequency(let renewalFrequency):
        state.track.renewalFrequency = renewalFrequency
        let numberStr = state.track.price.filter { $0.isNumber }
        if let deformattedPriceValue = Float(numberStr) {
          switch renewalFrequency {
          case .monthly:
            state.servicePricePerMonth = ""
          case .quarterly:
            state.servicePricePerMonth = "\((deformattedPriceValue / 4).roundedToDecimalPlaces())/month"
          case .yearly:
            state.servicePricePerMonth = "\((deformattedPriceValue / 12).roundedToDecimalPlaces())/month"
          }
        }
        return .none
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
      }
    }._printChanges()
  }
}

extension AddTrackFeature.State {
  struct SubscriptionServicePreset: Identifiable, Equatable, CustomStringConvertible  {
    let name: String
    let category: SubscriptionCategory

    var id: String { name }
    var description: String { name }
  }

  enum SubscriptionCategory: String, CaseIterable {
    case videoStreaming = "Video Streaming"
    case musicStreaming = "Music Streaming"
    case news = "News"
    case magazines = "Magazines"
    case productivity = "Productivity"
    case cloudStorage = "Cloud Storage"
    case fitness = "Fitness"
    case gaming = "Gaming"
    case education = "Education"
    case socialMedia = "Social Media"
    case dating = "Dating"
    case finance = "Finance"
    case software = "Software"
    case developerTools = "Developer Tools"
    case security = "Security"
    case vpn = "VPN"
    case webHosting = "Web Hosting"
    case ecommerce = "eCommerce"
  }

  static var popularSubscriptions: [SubscriptionServicePreset] {
    let raw: [String: SubscriptionCategory] = [
      "Netflix": .videoStreaming,
      "Hulu": .videoStreaming,
      "Disney+": .videoStreaming,
      "Spotify": .musicStreaming,
      "Apple Music": .musicStreaming,
      "Tidal": .musicStreaming,
      "New York Times": .news,
      "The Wall Street Journal": .news,
      "The Guardian": .news,
      "National Geographic": .magazines,
      "The Economist": .magazines,
      "Time Magazine": .magazines,
      "Evernote": .productivity,
      "Notion": .productivity,
      "Todoist": .productivity,
      "Dropbox": .cloudStorage,
      "Google Drive": .cloudStorage,
      "Microsoft OneDrive": .cloudStorage,
      "Peloton": .fitness,
      "MyFitnessPal": .fitness,
      "Strava": .fitness,
      "Xbox Game Pass": .gaming,
      "PlayStation Now": .gaming,
      "Nintendo Switch Online": .gaming,
      "Udemy": .education,
      "Coursera": .education,
      "Skillshare": .education,
      "Facebook": .socialMedia,
      "Twitter": .socialMedia,
      "Instagram": .socialMedia,
      "Tinder": .dating,
      "Bumble": .dating,
      "Hinge": .dating,
      "Mint": .finance,
      "QuickBooks": .finance,
      "Personal Capital": .finance,
      "Microsoft 365": .software,
      "Adobe Creative Cloud": .software,
      "AutoCAD": .software,
      "GitHub": .developerTools,
      "GitLab": .developerTools,
      "Bitbucket": .developerTools,
      "Norton": .security,
      "McAfee": .security,
      "Malwarebytes": .security,
      "NordVPN": .vpn,
      "ExpressVPN": .vpn,
      "Surfshark": .vpn,
      "Bluehost": .webHosting,
      "HostGator": .webHosting,
      "SiteGround": .webHosting,
      "Shopify": .ecommerce,
      "BigCommerce": .ecommerce,
      "WooCommerce": .ecommerce
    ]
    return raw.map { SubscriptionServicePreset(name: $0.key, category: $0.value) }
  }
}
