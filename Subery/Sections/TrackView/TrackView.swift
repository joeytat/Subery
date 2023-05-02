//
//  TrackView.swift
//  Subery
//
//  Created by yu wang on 2023/5/2.
//

import SwiftUI
import ComposableArchitecture

struct TrackView: View {
  let store: StoreOf<AppState>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading) {
        Text("Service Name")
          .font(.headline)
          .foregroundColor(.white)

        TextField("Apple Music", text: viewStore.binding(\.$serviceName))
          .padding()
          .background(Color.white)
          .cornerRadius(10)

        Spacer()
      }
      .padding(.horizontal, Theme.spacing.sm)
      .padding(.vertical, Theme.spacing.lg)
    }
    .background(GradientNoiseBackground())
  }
}

struct TrackView_Previews: PreviewProvider {
  static var previews: some View {
    TrackView(
      store: Store(
        initialState: AppState.State(),
        reducer: AppState()
      )
    )
  }
}
