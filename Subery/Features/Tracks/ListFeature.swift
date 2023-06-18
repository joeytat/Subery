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

struct TracksFeature: ReducerProtocol {
  struct State: Equatable {
    @PresentationState var addTrack: TrackFeature.State?
    @PresentationState var alert: AlertState<Action.Alert>?
    var tracks: IdentifiedArrayOf<Track> = []
  }
  
  enum Action {
    case addTrackButtonTapped
    case addTrack(PresentationAction<TrackFeature.Action>)
    case deleteButtonTapped(id: Track.ID)
    case alert(PresentationAction<Alert>)
    enum Alert: Equatable {
      case confirmDeletion(id: Track.ID)
    }
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
      case .addTrack(.presented(.delegate(.saveTrack(let track)))):
        state.tracks.append(track)
        return .none
      case .addTrack:
        return .none
      case .alert(.presented(.confirmDeletion(let id))):
        state.tracks.remove(id: id)
        return .none
      case .alert:
        return .none
      case .deleteButtonTapped(let id):
        state.alert = AlertState {
          TextState("Are you sure?")
        } actions: {
          ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
            TextState("Delete")
          }
        }
        return .none
      }
    }
    .ifLet(\.$addTrack, action: /Action.addTrack) {
      TrackFeature()
    }
    .ifLet(\.$alert, action: /Action.alert)
  }
}
