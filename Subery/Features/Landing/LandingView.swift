//
//  LandingView.swift
//  Subery
//
//  Created by yu wang on 2023/5/1.
//

import SwiftUI
import ComposableArchitecture

struct LandingView: View {
  let store: StoreOf<AddTrackFeature>

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: Theme.spacing.md) {
        Spacer()

        Text("All Your Subscriptions, Simplified.")
          .font(.title)
          .bold()
          .foregroundColor(Color.daisy.infoContent)

        Text("Keep track of all your monthly and annual subscriptions in one place. Never miss another renewal date or get surprised by unexpected fees again.")
          .font(.body)
          .foregroundColor(Color.daisy.secondary)
          .padding(.bottom, 32)

        NavigationLink(
          destination: AddTrackView(
            store: store
          )
          .navigationBarBackButtonHidden()
        ) {
          Text("Take Control Now")
            .formCTAButton()
        }

        Spacer()
      }
      .padding(.horizontal, Theme.spacing.sm)
    }
    .toolbarColorScheme(.light, for: .navigationBar)
  }
}

struct LandingView_Previews: PreviewProvider {
  static var previews: some View {
    LandingView(
      store: Store(
        initialState: AddTrackFeature.State(
          track: .init(
            id: UUID(),
            name: "Github Copilot",
            category: "AI",
            price: "9.99",
            startAtDate: Date(),
            endAtDate: Date(),
            renewalFrequency: .monthly
          )
        ),
        reducer: AddTrackFeature()
      )
    )
    .background(GradientBackgroundView())
  }
}
