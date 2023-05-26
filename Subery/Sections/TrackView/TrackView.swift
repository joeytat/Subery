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
  enum FormInput: String, Hashable {
    case name
    case category
    case price
    case startAt
    case endAt
  }

  let store: StoreOf<AppState>
  @FocusState var focusedField: FormInput?

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GradientBackgroundView().overlay {
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
              }
              .formCTAButton()
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
          .formInput()
          .focused($focusedField, equals: .name)
          .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)

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
          text: viewStore.binding(\.$servicePrice),
          focusState: $focusedField
        )
        .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)

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
                .formLabel()
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
        .formInput()
        .focused($focusedField, equals: .startAt)
        .onTapGesture { viewStore.send(.binding(.set(\.$isServiceDateStartPickerPresented, true))) }
        .sheet(isPresented: viewStore.binding(\.$isServiceDateStartPickerPresented)) {
          DatePickerView(
            date: viewStore.binding(\.$serviceStartAtDate),
            showingDatePicker: viewStore.binding(\.$isServiceDateStartPickerPresented)
          )
        }
        .formContainer()
        .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)
    }
  }

  private func serviceEndAt(_ viewStore: ViewStoreOf<AppState>) -> some View {
    VStack(alignment: .leading) {
      Text("End at")
        .formLabel()

      TextField(Date().format(), text: viewStore.binding(\.$serviceEndAt))
        .formInput()
        .focused($focusedField, equals: .endAt)
        .onTapGesture { viewStore.send(.binding(.set(\.$isServiceDateEndPickerPresented, true))) }
        .sheet(isPresented: viewStore.binding(\.$isServiceDateEndPickerPresented)) {
          DatePickerView(
            date: viewStore.binding(\.$serviceEndAtDate),
            showingDatePicker: viewStore.binding(\.$isServiceDateEndPickerPresented)
          )
        }
        .formContainer()
        .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)
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
      .focused($focusedField, equals: .category)
      .formInput()
      .formContainer()
      .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)
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
  var focusState: FocusState<TrackView.FormInput?>.Binding

  var body: some View {
    HStack(alignment: .firstTextBaseline, spacing: Theme.spacing.sm) {
      Text(prefix)
        .foregroundColor(.gray.opacity(0.5))
        .font(.body)

      TextField(placeholder, text: $text)
        .font(.body)
        .keyboardType(keyboardType)
        .padding(.trailing, suffixWidth() + 8)
        .overlay(
          Text(suffix)
            .foregroundColor(.gray.opacity(0.5))
            .font(.body)
            .offset(x: max(0, textWidth() + Theme.spacing.sm)),
          alignment: .leading
        )
        .focused(focusState, equals: .price)
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


extension View {
  func synchronize<Value>(
    _ first: Binding<Value>,
    _ second: FocusState<Value>.Binding
  ) -> some View {
    self
      .onChange(of: first.wrappedValue) { second.wrappedValue = $0 }
      .onChange(of: second.wrappedValue) { first.wrappedValue = $0 }
  }
}

