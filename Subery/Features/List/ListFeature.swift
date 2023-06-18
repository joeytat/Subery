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
  var startAtDate: Date
  var endAtDate: Date
  var renewalFrequency: RenewalFrequency
}

extension Track {
  enum RenewalFrequency: String, CaseIterable {
    case yearly = "Yearly"
    case quarterly = "Quarterly"
    case monthly = "Monthly"
  }
}

struct ListFeature: ReducerProtocol {
  struct State: Equatable {
    @PresentationState var addTrack: TrackFeature.State?
    var tracks: IdentifiedArrayOf<Track> = []
  }
  
  enum Action {
    case addTrackButtonTapped
    case addTrack(PresentationAction<TrackFeature.Action>)
  }
  
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .addTrackButtonTapped:
        state.addTrack = TrackFeature.State(
          track: .init(
            id: UUID(),
            name: "",
            category: "",
            price: "",
            startAtDate: Date(),
            endAtDate: Date(),
            renewalFrequency: .monthly
          )
        )
        return .none
      case .addTrack:
        return .none
      }
    }.ifLet(\.$addTrack, action: /Action.addTrack) {
      TrackFeature()
    }
  }
}
