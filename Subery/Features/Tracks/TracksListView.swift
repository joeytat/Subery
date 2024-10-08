//
//  ListView.swift
//  Subery
//
//  Created by yu wang on 2023/6/18.
//

import SwiftUI
import ComposableArchitecture

struct TracksListView: View {
  let store: StoreOf<TracksListFeature>

  var body: some View {
    WithViewStore(self.store, observe: \.tracks) { viewStore in
      ZStack(alignment: .bottom) {
        VStack {
          totalExpenses
          listHeader
            .background(Color.daisy.neutral)
          List {
            ForEach(viewStore.state) { track in
              itemView(track)
                .listRowInsets(
                  .init(
                    top: Theme.spacing.sm,
                    leading: Theme.spacing.lg,
                    bottom: Theme.spacing.sm,
                    trailing: Theme.spacing.lg
                  )
                )
                .listRowBackground(GradientBackgroundView())
            }.onDelete(perform: { _ in

            })
          }
          .listStyle(.plain)
        }
        .sheet(
          store: self.store.scope(
            state: \.$addTrack,
            action: { .addTrack($0) }
          )
        ) { store in
          NavigationStack {
            TrackFormView(store: store)
              .toolbar {
                ToolbarItem {
                  Button("form.save") {
                    viewStore.send(.saveTrackButtonTapped)
                  }
                  .foregroundColor(Color.daisy.neutralContent)
                }
                ToolbarItem(placement: .cancellationAction) {
                  Button("form.cancel") {
                    viewStore.send(.cancelTrackButtonTapped)
                  }
                  .foregroundColor(Color.daisy.neutralContent)
                }
              }
          }
        }
        Button(action: {
          viewStore.send(.addButtonTapped)
        }) {
          Text("list.track")
            .modifier(FormCTAButtonModifier())
        }
      }
      .background(Color.daisy.neutral)
    }
  }

  private var totalExpenses: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      HStack {
        VStack(alignment: .leading, spacing: Theme.spacing.lg) {
          Text("list.total.month")
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
        Text("list.item.title")
          .font(.headline)
          .foregroundColor(Color.white)

        Spacer()

        Text("list.item.price")
          .font(.headline)
          .foregroundColor(Color.white)
      }
      .padding()

      Divider()
        .background(Color.daisy.neutralContent)
    }
  }

  private func itemView(_ track: Track) -> some View {
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
  }
}

#Preview {
  NavigationStack {
    TracksListView(
      store: Store(
        initialState: TracksListFeature.State(tracks: [.mock]),
        reducer: {
          TracksListFeature()
        }
      )
    )
  }
}
