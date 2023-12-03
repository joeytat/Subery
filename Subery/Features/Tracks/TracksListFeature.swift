//
//  TracksFeature.swift
//  Subery
//
//  Created by yu wang on 2023/6/18.
//

import Foundation
import ComposableArchitecture

struct TracksListFeature: Reducer {
  struct State: Equatable {
    @PresentationState var destination: Destination.State?

    var tracks: IdentifiedArrayOf<Track> = []
    var isAddTrackPresneted: Bool = false
    var totalAmount: String {
      let total = tracks.reduce(into: Float(0.0)) { acc, next in
        if let price = Float(next.price) {
          acc += price
        }
      }
      .roundedToDecimalPlaces()

      return "$\(total)"
    }
  }

  enum Action {
    enum Alert: Equatable {
      case confirmDeletion(id: Track.ID)
    }

    case addButtonTapped
    case deleteButtonTapped(id: Track.ID)
    case destination(PresentationAction<Destination.Action>)
  }
  @Dependency(\.uuid) var uuid

  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.tracks.append(.mock)
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
      }
    }
    .ifLet(\.$destination, action: /Action.destination) {
      Destination()
    }
  }
}

extension TracksListFeature {
  struct Destination: Reducer {
    enum State: Equatable {
      case addTrack(TrackFormFeature.State)
      case alert(AlertState<TracksListFeature.Action.Alert>)
    }

    enum Action {
      case addTrack(TrackFormFeature.Action)
      case alert(TracksListFeature.Action.Alert)
    }

    var body: some ReducerOf<Self> {
      Scope(state: /State.addTrack, action: /Action.addTrack) {
        TrackFormFeature()
      }
    }
  }
}
