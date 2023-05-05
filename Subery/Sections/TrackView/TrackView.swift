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
      GradientNoiseBackground().overlay {
        VStack(alignment: .leading, spacing: Theme.spacing.lg) {
          Form {
            serviceName(viewStore)
            servicePrice(viewStore)
            HStack(spacing: Theme.spacing.lg) {
              serviceStartAt(viewStore)
              serviceEndAt(viewStore)
            }
            Spacer()
          }
          .monospacedDigit()
          .formStyle(.columns)
          .padding(.horizontal, Theme.spacing.sm)
          .padding(.vertical, Theme.spacing.lg)
        }
      }
    }
  }

  private func serviceName(_ viewStore: ViewStoreOf<AppState>) -> some View {
    VStack(alignment: .leading) {
      Text("Service Name")
        .font(.headline)
        .foregroundColor(.white)

      TextField("Apple Music", text: viewStore.binding(\.$serviceName))
        .font(.body)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
  }

  private func servicePrice(_ viewStore: ViewStoreOf<AppState>) -> some View {
    VStack(alignment: .leading) {
      Text("Price")
        .font(.headline)
        .foregroundColor(.white)

      HStack {
        TextFieldWithPrefix(
          prefix: "$",
          placeholder: "6.00",
          keyboardType: .numberPad,
          text: viewStore.binding(\.$servicePrice)
        )
        Dropdown(label: {
          HStack {
            Text(viewStore.serviceRenewalFrequency.rawValue)
              .foregroundColor(.primary)
            Image(systemName: "chevron.down")
              .foregroundColor(Color.lightGray)
          }
        }) {
          ForEach(AppState.State.RenewalFrequency.allCases, id: \.self) { option in
            Button(action: {
              viewStore.send(.setRenewalFrequency(option))
            }) {
              Text(option.rawValue)
                .background(Color.white)
                .foregroundColor(.primary)
            }
          }
        }
      }
      .padding()
      .background(Color.white)
      .cornerRadius(10)
    }
  }

  private func serviceStartAt(_ viewStore: ViewStoreOf<AppState>) -> some View {
    VStack(alignment: .leading) {
      Text("Start at")
        .font(.headline)
        .foregroundColor(.white)

      TextField(Date().format(), text: viewStore.binding(\.$serviceStartAt))
        .font(.body)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .onTapGesture { viewStore.send(.binding(.set(\.$isServiceDateStartPickerPresented, true))) }
        .sheet(isPresented: viewStore.binding(\.$isServiceDateStartPickerPresented)) {
          DatePickerView(
            date: viewStore.binding(\.$serviceStartAtDate),
            showingDatePicker: viewStore.binding(\.$isServiceDateStartPickerPresented)
          )
        }
    }
  }

  private func serviceEndAt(_ viewStore: ViewStoreOf<AppState>) -> some View {
    VStack(alignment: .leading) {
      Text("End at")
        .font(.headline)
        .foregroundColor(.white)

      TextField(Date().format(), text: viewStore.binding(\.$serviceEndAt))
        .font(.body)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .onTapGesture { viewStore.send(.binding(.set(\.$isServiceDateEndPickerPresented, true))) }
        .sheet(isPresented: viewStore.binding(\.$isServiceDateEndPickerPresented)) {
          DatePickerView(
            date: viewStore.binding(\.$serviceEndAtDate),
            showingDatePicker: viewStore.binding(\.$isServiceDateEndPickerPresented)
          )
        }
    }
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
