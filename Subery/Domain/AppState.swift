//
//  Feature.swift
//  Subery
//
//  Created by yu wang on 2023/5/1.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct AppState: ReducerProtocol {
  struct State: Equatable {
    // Track
    var placeholderService: SubscriptionServicePreset = State.popularSubscriptions.randomElement()!
    var serviceSuggestions: IdentifiedArrayOf<SubscriptionServicePreset> = []

    @BindingState var serviceName: String = ""
    @BindingState var serviceCategory: String = ""
    @BindingState var servicePrice: String = ""
    @BindingState var servicePricePerMonth: String = ""
    enum RenewalFrequency: String, CaseIterable {
      case yearly = "Yearly"
      case quarterly = "Quarterly"
      case monthly = "Monthly"
    }
    var serviceRenewalFrequency: RenewalFrequency = .monthly

    @BindingState var serviceStartAt: String = ""
    @BindingState var serviceStartAtDate: Date = Date()
    @BindingState var isServiceDateStartPickerPresented: Bool = false

    @BindingState var serviceEndAt: String = ""
    @BindingState var serviceEndAtDate: Date = Date()
    @BindingState var isServiceDateEndPickerPresented: Bool = false

    @BindingState var serviceFocusedInput: TrackView.FormInput?
  }

  enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case setRenewalFrequency(State.RenewalFrequency)
  }

  var body: some ReducerProtocol<State, Action> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding(\.$serviceName):
        if !state.serviceName.isEmpty {
          let suggestionsResult: IdentifiedArrayOf<AppState.State.SubscriptionServicePreset> = IdentifiedArray(
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
        if let deformattedPriceValue = Float(numberStr)?.roundedToDecimalPlaces() {
          state.servicePrice = deformattedPriceValue.formatted()
          switch state.serviceRenewalFrequency {
          case .monthly:
            state.servicePricePerMonth = ""
          case .quarterly:
            state.servicePricePerMonth = "(\((deformattedPriceValue / 4).roundedToDecimalPlaces())/month)"
          case .yearly:
            state.servicePricePerMonth = "(\((deformattedPriceValue / 12).roundedToDecimalPlaces())/month)"
          }
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
            state.servicePricePerMonth = "(\((deformattedPriceValue / 4).roundedToDecimalPlaces())/month)"
          case .yearly:
            state.servicePricePerMonth = "(\((deformattedPriceValue / 12).roundedToDecimalPlaces())/month)"
          }
        }
        return .none
      case .binding:
        return .none
      }
    }._printChanges()
  }
}

extension AppState.State {
  struct SubscriptionServicePreset: Identifiable, Equatable  {
    var id: String { name }
    let name: String
    let category: SubscriptionCategory
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
