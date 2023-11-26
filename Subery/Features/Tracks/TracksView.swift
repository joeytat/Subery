//
//  ListView.swift
//  Subery
//
//  Created by yu wang on 2023/6/18.
//

import SwiftUI
import ComposableArchitecture

struct TracksView: View {
  let store: StoreOf<TracksFeature>
  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack(alignment: .bottom) {
        VStack {
          totalExpenses
          listHeader
            .background(Color.daisy.neutral)
          list
        }
        Button(action: {
          viewStore.send(.setAddTrackView(presented: true))
        }) {
          Text("Track Subscription")
            .modifier(FormCTAButtonModifier())
        }
      }
      .sheet(
        isPresented: viewStore.binding(
          get: \.isAddTrackPresneted,
          send: { .setAddTrackView(presented: $0) }),
        content: {
          NavigationView {
            AddTrackView(
              store: .init(
                initialState: AddTrackFeature.State(
                  track: .init(id: UUID())
                )
              ) {
                AddTrackFeature()
              }
            )
          }
        }
      )
      .background(Color.daisy.neutral)
    }
  }

  private var totalExpenses: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        VStack(alignment: .leading, spacing: Theme.spacing.lg) {
          Text("What you've paid")
            .font(.body)
            .fontWeight(.medium)
            .foregroundColor(Color.daisy.neutralContent)

          Text(viewStore.totalAmount)
            .font(.title)
            .fontWeight(.medium)
            .foregroundColor(Color.white)
        }
        Spacer()
      }
      .padding()
    }
  }

  private var listHeader: some View {
    VStack {
      Divider()
        .background(Color.daisy.neutralContent)

      HStack {
        Text("Service")
          .font(.headline)
          .foregroundColor(Color.white)

        Spacer()

        Text("Price")
          .font(.headline)
          .foregroundColor(Color.white)
      }
      .padding()

      Divider()
        .background(Color.daisy.neutralContent)
    }
  }

  private var list: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        ForEach(viewStore.tracks) { track in
          VStack {
            HStack {
              VStack(alignment: .leading) {
                Text(track.name)
                  .font(.headline)
                  .foregroundColor(Color.white)

                Text(track.category)
                  .font(.body)
                  .foregroundColor(Color.daisy.neutralContent)
              }

              Spacer()

              Text(track.currency.symbol + track.price)
                .font(.headline)
                .foregroundColor(Color.white)
            }

            Divider()
              .background(Color.daisy.neutralContent)
          }
          .swipeActions(edge: .trailing) {
            Button {
              viewStore.send(.deleteButtonTapped(id: track.id))
            } label: {
              Image(systemName: "trash")
                .foregroundColor(Color.daisy.warning)
            }
          }
          .listRowBackground(GradientBackgroundView())
        }
      }
      .listStyle(PlainListStyle())
      .sheet(
        store: self.store.scope(state: \.$destination, action: { .destination($0) }),
        state: /TracksFeature.Destination.State.addTrack,
        action: TracksFeature.Destination.Action.addTrack
      ) { addTrackStore in
        NavigationStack {
          AddTrackView(store: addTrackStore)
        }
      }
      .alert(
        store: self.store.scope(state: \.$destination, action: { .destination($0) }),
        state: /TracksFeature.Destination.State.alert,
        action: TracksFeature.Destination.Action.alert
      )
    }
  }
}

#Preview {
  TracksView(
    store: Store(
      initialState: TracksFeature.State(),
      reducer: {
        TracksFeature()
      }
    )
  )
}
