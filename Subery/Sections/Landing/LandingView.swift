//
//  LandingView.swift
//  Subery
//
//  Created by yu wang on 2023/5/1.
//

import SwiftUI
import ComposableArchitecture

struct LandingView: View {
  let store: StoreOf<AppState>

  var body: some View {
    HStack {
      WithViewStore(self.store, observe: { $0 }) { viewStore in
        VStack(alignment: .leading, spacing: 12) {
          Text("All Your Subscriptions, Simplified.")
            .font(.title)
            .bold()
            .foregroundColor(.white)

          Text("Keep track of all your monthly and annual subscriptions in one place. Never miss another renewal date or get surprised by unexpected fees again.")
            .font(.body)
            .foregroundColor(.lightGray)
            .padding(.bottom, 32)

          Button(
            action: {
              viewStore.send(.landingControlButtonTapped)
            },
            label: {
              Text("Take Control Now")
                .font(.headline)
            }
          )
          .buttonStyle(NeuButtonStyle())

        }
      }
      .padding()
    }
  }
}

struct LandingView_Previews: PreviewProvider {
  static var previews: some View {
    LandingView(
      store: Store(
        initialState: AppState.State(),
        reducer: AppState()
      )
    )
  }
}
