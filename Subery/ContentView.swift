//
//  ContentView.swift
//  Subery
//
//  Created by yu wang on 2023/4/30.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      LinearBackgroundView()

      HStack {
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

            }, label: {
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


struct LinearBackgroundView: View {
  var body: some View {
    ZStack {
      LinearGradient(
        gradient: Gradient(colors: [Color.black, Color.accentColor]),
        startPoint: .bottomLeading,
        endPoint: .topTrailing
      )
      .edgesIgnoringSafeArea(.all)
    }
  }
}
