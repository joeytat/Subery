//
//  ListFeature.swift
//  Subery
//
//  Created by yu wang on 2023/6/18.
//

import Foundation
import ComposableArchitecture

struct Track: Equatable, Identifiable {
  let id: UUID
  var name: String
  var category: String
  var price: String
  var startAt: String
  var startAtDate: Date
  var endAt: String
  var endAtDate: Date
  var renewalFrequency: TrackFeature.State.RenewalFrequency
}

struct ListFeature: ReducerProtocol {
  struct State: Equatable {
    var tracks: IdentifiedArrayOf<Track> = []
  }
  
  enum Action {
    case addTrackButtonTapped
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .addTrackButtonTapped:
        return .none
      }
    }
  }
}
