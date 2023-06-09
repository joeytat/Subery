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
    NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) } )) {
      WithViewStore(self.store) { viewStore in
        VStack {
          listHeader
            .background(Color.daisy.neutral)
          list
        }
        .background(Color.daisy.neutral)
      }
      .background(Color.daisy.neutral)
      .navigationBarTitleDisplayMode(.inline)
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Subery")
            .foregroundColor(Color.white)
            .font(.title2)
            .fontWeight(.bold)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          NavigationLink(
            state: AddTrackFeature.State(
              track: .init(id: UUID())
            )
          ) {
            Image(systemName: "plus.app.fill")
              .foregroundColor(Color.daisy.accent)
              .font(.title3)
              .fontWeight(.semibold)
          }
        }
      }
    } destination: { store in
      AddTrackView(store: store)
    }
  }

  private var listHeader: some View {
    WithViewStore(self.store) { viewStore in
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
  }

  private var list: some View {
    WithViewStore(self.store) { viewStore in
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

              Text(track.price)
                .foregroundColor(Color.daisy.neutralContent)
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

struct TracksView_Previews: PreviewProvider {
  static var previews: some View {
    TracksView(
      store: Store(
        initialState: TracksFeature.State(
          tracks: [
            .init(
              id: UUID(),
              name: "Github Copilot",
              price: "9.99"
            ),
            .init(
              id: UUID(),
              name: "Midjourney",
              price: "9.99"
            ),
            .init(
              id: UUID(),
              name: "Netflix",
              price: "9.99"
            )
          ]
        ),
        reducer: TracksFeature()
      )
    )
  }
}
