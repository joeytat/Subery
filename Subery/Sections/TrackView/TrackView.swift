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
            VStack(spacing: Theme.spacing.xl) {
              serviceName(viewStore)
              serviceCategory(viewStore)
              servicePrice(viewStore)
              HStack(spacing: Theme.spacing.lg) {
                serviceStartAt(viewStore)
                serviceEndAt(viewStore)
              }
            }
            Spacer()

            HStack {
              Spacer()

              NavigationLink(destination: TrackView(store: store)) {
                Text("Save Subscription")
                  .font(.headline)
                  .foregroundColor(Color.dark)
                  .bevelStyle()
              }
            }
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
      Text("App / Service Name")
        .formLabel()

      VStack(spacing: 0) {
        TextField(viewStore.placeholderService.name, text: viewStore.binding(\.$serviceName))
          .foregroundColor(Color.white)
          .font(.body)
          .padding()

        if !viewStore.state.serviceSuggestions.isEmpty {
          serviceSuggestion(viewStore)
        }
      }
      .padding(.bottom, viewStore.state.serviceSuggestions.isEmpty ? 0 : Theme.spacing.sm)
      .formContainer()
    }
  }

  private func serviceSuggestion(_ viewStore: ViewStoreOf<AppState>) -> some View {
    ScrollView {
      VStack {
        ForEach(viewStore.serviceSuggestions) { service in
          VStack(alignment: .leading) {
            Divider()
            Text(service.name)
              .font(.callout)
              .foregroundColor(Color.lightGray)
              .frame(height: 40)
              .onTapGesture {
                viewStore.send(.binding(.set(\.$serviceName, service.name)))
              }
          }
        }
      }
    }
    .frame(maxHeight: CGFloat.minimum(40 * CGFloat(viewStore.serviceSuggestions.count), 120))
    .padding(.horizontal)
    .transition(.slide)
    .animation(.spring(), value: viewStore.state.serviceSuggestions)
  }

  private func servicePrice(_ viewStore: ViewStoreOf<AppState>) -> some View {
    VStack(alignment: .leading) {
      Text("Price")
        .formLabel()

      HStack {
        PriceTextField(
          prefix: "$",
          suffix: viewStore.servicePricePerMonth,
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
      .formContainer()
    }
  }

  private func serviceStartAt(_ viewStore: ViewStoreOf<AppState>) -> some View {
    VStack(alignment: .leading) {
      Text("Start at")
        .formLabel()

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
        .formLabel()

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

  private func serviceCategory(_ viewStore: ViewStoreOf<AppState>) -> some View {
    VStack(alignment: .leading) {
      Text("Category")
        .formLabel()

      TextField(
        viewStore.placeholderService.category.rawValue,
        text: viewStore.binding(\.$serviceCategory)
      )
      .font(.body)
      .padding()
      .formContainer()
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


struct PriceTextField: View {
  let prefix: String
  let suffix: String
  let placeholder: String
  let keyboardType: UIKeyboardType

  @Binding var text: String

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.sm) {
      Text(prefix)
        .foregroundColor(.gray.opacity(0.5))
        .font(.body)

      TextField(placeholder, text: $text)
        .keyboardType(keyboardType)
        .padding(.trailing, suffixWidth() + 8)
        .overlay(
          Text(suffix)
            .foregroundColor(.gray.opacity(0.5))
            .font(.body)
            .offset(x: max(0, textWidth() + Theme.spacing.sm)),
          alignment: .leading
        )
    }
  }

  private func textWidth() -> CGFloat {
    let font = UIFont.preferredFont(forTextStyle: .body)
    let string = NSString(string: text.isEmpty ? placeholder : text)
    let attributes = [NSAttributedString.Key.font: font]
    let size = string.size(withAttributes: attributes)
    return size.width
  }

  private func suffixWidth() -> CGFloat {
    let font = UIFont.preferredFont(forTextStyle: .body)
    let string = NSString(string: suffix)
    let attributes = [NSAttributedString.Key.font: font]
    let size = string.size(withAttributes: attributes)
    return size.width
  }
}
