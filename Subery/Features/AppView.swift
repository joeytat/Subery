//
//  ContentView.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI
import ComposableArchitecture

struct AppFeature: Reducer {
    struct State {
        var trackList = TracksListFeature.State()
    }
    enum Action {
        case trackList(TracksListFeature.Action)
    }
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .trackList:
                return .none
            }
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>

    var body: some View {
        NavigationStack {
            TracksListView(
                store: self.store.scope(state: \.trackList, action: { .trackList($0) })
            )
        }
        .preferredColorScheme(.light)
    }
}

#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
