//
//  TracksFeature.swift
//  Subery
//
//  Created by yu wang on 2023/6/18.
//

import Foundation
import ComposableArchitecture

struct Track: Equatable, Identifiable {
  let id: UUID
  var name: String = ""
  var category: String = ""
  var price: String = ""
  var startAtDate: Date = Date()
  var endAtDate: Date = Date()
  var renewalFrequency: RenewalFrequency = .monthly
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
    @PresentationState var destination: Destination.State?

    var path = StackState<AddTrackFeature.State>()
    var tracks: IdentifiedArrayOf<Track> = []
  }
  
  enum Action {
    enum Alert: Equatable {
      case confirmDeletion(id: Track.ID)
    }

    case addTrackButtonTapped
    case deleteButtonTapped(id: Track.ID)
    case destination(PresentationAction<Destination.Action>)
    case path(StackAction<AddTrackFeature.State,  AddTrackFeature.Action>)
  }
  @Dependency(\.uuid) var uuid
  var body: some ReducerProtocolOf<Self> {
    Reduce { state, action in
      switch action {
      case .addTrackButtonTapped:
        state.destination = .addTrack(
          AddTrackFeature.State(
            track: .init(
              id: self.uuid()
            )
          )
        )
        return .none
      case .destination(.presented(.addTrack(.delegate(.saveTrack(let track))))):
        state.tracks.append(track)
        return .none
      case .destination(.presented(.alert(.confirmDeletion(let id)))):
        state.tracks.remove(id: id)
        return .none
      case .deleteButtonTapped(let id):
        state.destination = .alert(
          AlertState {
            TextState("Are you sure")
          } actions: {
            ButtonState(role: .destructive, action: .confirmDeletion(id: id)) {
              TextState("Delete")
            }
          }
        )
        return .none
      case .destination:
        return .none
      case let .path(.element(_, action: .delegate(.saveTrack(track)))):
        //        guard let addTrackState = state.path[id: id] else { return .none }
        state.tracks.append(track)
        return .none
      case .path:
        return .none
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
    .forEach(\.path, action: /Action.path) {
      AddTrackFeature()
    }
  }
}

extension TracksFeature {
  struct Destination: ReducerProtocol {
    enum State: Equatable {
      case addTrack(AddTrackFeature.State)
      case alert(AlertState<TracksFeature.Action.Alert>)
    }

    enum Action {
      case addTrack(AddTrackFeature.Action)
      case alert(TracksFeature.Action.Alert)
    }

    var body: some ReducerProtocolOf<Self> {
      Scope(state: /State.addTrack, action: /Action.addTrack) {
        AddTrackFeature()
      }
    }
  }
}
