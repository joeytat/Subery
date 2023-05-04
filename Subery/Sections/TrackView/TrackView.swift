//
//  TrackView.swift
//  Subery
//
//  Created by yu wang on 2023/5/2.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct TrackView: View {
  let store: StoreOf<AppState>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GeometryReader { geometry in
        ScrollView {
          VStack(alignment: .leading, spacing: Theme.spacing.lg) {
            VStack(alignment: .leading) {
              Text("Service Name")
                .font(.headline)
                .foregroundColor(.white)

              TextField("Apple Music", text: viewStore.binding(\.$serviceName))
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }

            VStack(alignment: .leading) {
              Text("Price")
                .font(.headline)
                .foregroundColor(.white)

              TextFieldWithPrefix(
                prefix: "$",
                placeholder: "6.00",
                keyboardType: .numberPad,
                text: viewStore.binding(\.$servicePrice)
              )
              .padding()
              .background(Color.white)
              .cornerRadius(10)
            }
          }
          .padding(.horizontal, Theme.spacing.sm)
          .padding(.vertical, Theme.spacing.lg)
          .offset(y: geometry.size.height / 4)
        }
      }
    }
    .modifier(AdaptiveKeyboardPadding())
  }
}



struct TrackView_Previews: PreviewProvider {
  static var previews: some View {
    GradientNoiseBackground().overlay {
      TrackView(
        store: Store(
          initialState: AppState.State(),
          reducer: AppState()
        )
      )
    }
  }
}


struct TextFieldWithPrefix: View {
  let prefix: String
  let placeholder: String
  let keyboardType: UIKeyboardType

  @Binding var text: String

  var body: some View {
    HStack {
      Text(prefix)
        .foregroundColor(.gray.opacity(0.5))
        .font(.body)

      TextField(placeholder, text: $text)
        .keyboardType(keyboardType)
        .font(.body)
    }
  }
}

struct AdaptiveKeyboardPadding: ViewModifier {
  @State private var keyboardPadding: CGFloat = 0

  func body(content: Content) -> some View {
    content
      .padding(.bottom, keyboardPadding)
      .onAppear(perform: addKeyboardObservers)
      .onDisappear(perform: removeKeyboardObservers)
  }

  private func addKeyboardObservers() {
    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardWillShowNotification,
      object: nil,
      queue: .main
    ) { notification in
      let keyWindow = UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first { $0.isKeyWindow }
      let bottomInset = keyWindow?.safeAreaInsets.bottom ?? 0
      keyboardPadding = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 - bottomInset
    }

    NotificationCenter.default.addObserver(
      forName: UIResponder.keyboardWillHideNotification,
      object: nil,
      queue: .main
    ) { _ in
      keyboardPadding = 0
    }
  }

  private func removeKeyboardObservers() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }
}
