//
//  ListView.swift
//  Subery
//
//  Created by yu wang on 2023/6/18.
//

import SwiftUI
import ComposableArchitecture

struct ListView: View {
  let store: StoreOf<ListFeature>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationView {
        List {
          ForEach(viewStore.tracks) { track in
            HStack {
              VStack(alignment: .leading) {
                Text(track.name)
                Text(track.category)
              }
              Spacer()
              Text(track.price)
            }
            .swipeActions(edge: .trailing) {
              Button {
                viewStore.send(.deleteButtonTapped(id: track.id))
              } label: {
                Image(systemName: "trash")
                  .foregroundColor(Color.daisy.warning)
              }
            }
          }
        }
        .navigationTitle("Subery")
        .navigationBarItems(
          trailing: Button(
            action: {
              viewStore.send(.addTrackButtonTapped)
            },
            label: {
              Text("Add")
            }
          )
        )
        .sheet(
          store: self.store.scope(
            state: \.$addTrack,
            action: { .addTrack($0) })
        ) { addTrackStore in
          NavigationStack {
            TrackView(store: addTrackStore)
          }
        }
        .alert(
          store: self.store.scope(
            state: \.$alert,
            action: { .alert($0) }
          )
        )
      }
    }
  }
}

struct ListView_Previews: PreviewProvider {
  static var previews: some View {
    ListView(store: Store(
      initialState: ListFeature.State(
        tracks: [
          .init(
            id: UUID(),
            name: "Github Copilot",
            category: "AI",
            price: "9.99",
            startAtDate: Date(),
            endAtDate: Date(),
            renewalFrequency: .monthly
          ),
          .init(
            id: UUID(),
            name: "Midjourney",
            category: "AI",
            price: "9.99",
            startAtDate: Date(),
            endAtDate: Date(),
            renewalFrequency: .yearly
          ),
          .init(
            id: UUID(),
            name: "Netflix",
            category: "Video Streaming",
            price: "9.99",
            startAtDate: Date(),
            endAtDate: Date(),
            renewalFrequency: .yearly
          )
        ]),
      reducer: ListFeature()
    )
    )
  }
}
