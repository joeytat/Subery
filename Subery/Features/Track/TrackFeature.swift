//
//  Feature.swift
//  Subery
//
//  Created by yu wang on 2023/5/1.
//

import Foundation
import ComposableArchitecture

struct TrackFeature: ReducerProtocol {
  struct State: Equatable {
    var placeholderService: SubscriptionServicePreset = State.popularSubscriptions.randomElement()!
    var serviceSuggestions: IdentifiedArrayOf<SubscriptionServicePreset> = []

    @BindingState var serviceName: String = ""
    @BindingState var serviceCategory: String = ""
    @BindingState var servicePrice: String = ""
    @BindingState var serviceStartAt: String = ""
    @BindingState var serviceStartAtDate: Date = Date()
    @BindingState var serviceEndAt: String = ""
    @BindingState var serviceEndAtDate: Date = Date()
    var serviceRenewalFrequency: RenewalFrequency = .monthly

    var serviceNameError: String?
    var serviceCategoryError: String?
    var servicePriceError: String?
    var serviceStartAtError: String?
    var serviceEndAtError: String?

    @BindingState var servicePricePerMonth: String = ""
    @BindingState var isServiceDateStartPickerPresented: Bool = false
    @BindingState var isServiceDateEndPickerPresented: Bool = false
    @BindingState var serviceFocusedInput: TrackView.FormInput?
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case setRenewalFrequency(State.RenewalFrequency)
    case onSaveButtonTapped
  }

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.$serviceName):
        if !state.serviceName.isEmpty {
          let suggestionsResult: IdentifiedArrayOf<TrackFeature.State.SubscriptionServicePreset> = IdentifiedArray(
            uniqueElements: State.popularSubscriptions
              .filter { $0.name.lowercased().starts(with: state.serviceName.lowercased()) }
          )
          if suggestionsResult.count == 1,
             let firstPreset = suggestionsResult.first,
             firstPreset.name == state.serviceName {
            state.serviceSuggestions = []
            state.serviceCategory = firstPreset.category.rawValue
          } else {
            state.serviceSuggestions = suggestionsResult
          }
          state.serviceNameError = nil
        } else {
          state.serviceSuggestions = []
        }
        return .none
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
        if let deformattedPriceValue = Float(numberStr)?.roundedToDecimalPlaces(), deformattedPriceValue > 0 {
          state.servicePrice = deformattedPriceValue.formatted()
          switch state.serviceRenewalFrequency {
          case .monthly:
            state.servicePricePerMonth = ""
          case .quarterly:
            state.servicePricePerMonth = "\((deformattedPriceValue / 4).roundedToDecimalPlaces())/month"
          case .yearly:
            state.servicePricePerMonth = "\((deformattedPriceValue / 12).roundedToDecimalPlaces())/month"
          }
          state.servicePriceError = nil
        } else {
          state.servicePrice = Float(state.servicePrice)?.formatted() ?? ""
        }
        return .none
      case .setRenewalFrequency(let renewalFrequency):
        state.serviceRenewalFrequency = renewalFrequency
        let numberStr = state.servicePrice.filter { $0.isNumber }
        if let deformattedPriceValue = Float(numberStr) {
          switch state.serviceRenewalFrequency {
          case .monthly:
            state.servicePricePerMonth = ""
          case .quarterly:
            state.servicePricePerMonth = "\((deformattedPriceValue / 4).roundedToDecimalPlaces())/month"
          case .yearly:
            state.servicePricePerMonth = "\((deformattedPriceValue / 12).roundedToDecimalPlaces())/month"
          }
        }
        return .none
      case .binding:
        return .none
      case .onSaveButtonTapped:
        if state.serviceName.isEmpty {
          state.serviceNameError = "Service name is required"
          return .none
        }

        if state.serviceCategory.isEmpty {
          state.serviceCategoryError = "Service category is required"
          return .none
        }

        if state.servicePrice.isEmpty {
          state.servicePriceError = "Service price is required"
          return .none
        }

        if let price = Float(state.servicePrice.filter { $0.isNumber }), price <= 0 {
          state.servicePriceError = "Service price should be greater than 0"
          return .none
        }

        if state.serviceStartAt.isEmpty {
          state.serviceStartAtError = "Service start date is required"
          return .none
        }

        if state.serviceEndAt.isEmpty {
          state.serviceEndAtError = "Service end date is required"
          return .none
        }

        if state.serviceStartAtDate > state.serviceEndAtDate {
          state.serviceEndAtError = "Service end date should be after start date"
          return .none
        }

        return .none
      }
    }._printChanges()
  }
}

extension TrackFeature.State {
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

extension TrackFeature.State {
  enum RenewalFrequency: String, CaseIterable {
    case yearly = "Yearly"
    case quarterly = "Quarterly"
    case monthly = "Monthly"
  }
}
