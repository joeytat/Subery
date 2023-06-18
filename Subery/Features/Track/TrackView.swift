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

  let store: StoreOf<TrackFeature>
  @FocusState var focusedField: FormInput?
  @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      GradientBackgroundView().overlay {
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
            Button {
              presentationMode.wrappedValue.dismiss()
            } label: {
              Text("Back")
            }
            .formCancelButton()
            
            Spacer()

            Button {
              viewStore.send(.onSaveButtonTapped)
            } label: {
              Text("Save")
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

  private func serviceName(_ viewStore: ViewStoreOf<TrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("App / Service Name")
        .formLabel()

      TextField(
        "",
        text: viewStore.binding(\.$serviceName)
      )
      .focused($focusedField, equals: .name)
      .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)
      .formInput(
        placeholder: viewStore.placeholderService.name,
        isEmpty: viewStore.serviceName.isEmpty,
        isFocused: focusedField == .name,
        suggestions: viewStore.state.serviceSuggestions.map { $0.name },
        onSuggestionTapped: { suggestion in
          viewStore.send(.binding(.set(\.$serviceName, suggestion)))
        }
      )
      .padding(
        .bottom, viewStore.state.serviceSuggestions.isEmpty ? 0 : Theme.spacing.sm
      )

      if let error = viewStore.serviceNameError {
        Text(error)
          .formError()
      }
    }
  }

  private func servicePrice(_ viewStore: ViewStoreOf<TrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("Price")
        .formLabel()

      TextField(
        "",
        text: viewStore.binding(\.$servicePrice)
      )
      .keyboardType(.numberPad)
      .focused($focusedField, equals: .price)
      .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)
      .formInput(
        isEmpty: viewStore.serviceName.isEmpty,
        isFocused: focusedField == .price,
        prefix: (
          Text("$")
            .foregroundColor(Color.daisy.secondary)
            .font(.body)
            .padding(.trailing, Theme.spacing.ssm)
        ),
        suffix: (
          Dropdown(label: {
            HStack {
              Text(viewStore.serviceRenewalFrequency.rawValue)
                .foregroundColor(Color.daisy.infoContent)
              Image(systemName: "chevron.down")
                .foregroundColor(Color.daisy.secondary)
            }
          }) {
            ForEach(TrackFeature.State.RenewalFrequency.allCases, id: \.self) { option in
              Button(action: {
                viewStore.send(.setRenewalFrequency(option))
              }) {
                Text(option.rawValue)
                  .formLabel()
              }
            }
          }
        )
      )

      if !viewStore.servicePricePerMonth.isEmpty {
        Text(viewStore.servicePricePerMonth)
          .font(.caption)
          .foregroundColor(Color.daisy.secondary)
      }

      if let error = viewStore.servicePriceError {
        Text(error)
          .formError()
      }
    }
  }

  private func serviceStartAt(_ viewStore: ViewStoreOf<TrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("Start at")
        .formLabel()

      TextField("", text: viewStore.binding(\.$serviceStartAt))
        .formInput(
          placeholder: Date().format(),
          isEmpty: viewStore.serviceStartAt.isEmpty,
          isFocused: focusedField == .startAt
        )
        .focused($focusedField, equals: .startAt)
        .onTapGesture { viewStore.send(.binding(.set(\.$isServiceDateStartPickerPresented, true))) }
        .sheet(isPresented: viewStore.binding(\.$isServiceDateStartPickerPresented)) {
          DatePickerView(
            date: viewStore.binding(\.$serviceStartAtDate),
            showingDatePicker: viewStore.binding(\.$isServiceDateStartPickerPresented)
          )
        }
        .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)
    }
  }

  private func serviceEndAt(_ viewStore: ViewStoreOf<TrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("End at")
        .formLabel()

      TextField("", text: viewStore.binding(\.$serviceEndAt))
        .formInput(
          placeholder: Date().format(),
          isEmpty: viewStore.serviceEndAt.isEmpty,
          isFocused: focusedField == .endAt
        )
        .focused($focusedField, equals: .endAt)
        .onTapGesture { viewStore.send(.binding(.set(\.$isServiceDateEndPickerPresented, true))) }
        .sheet(isPresented: viewStore.binding(\.$isServiceDateEndPickerPresented)) {
          DatePickerView(
            date: viewStore.binding(\.$serviceEndAtDate),
            showingDatePicker: viewStore.binding(\.$isServiceDateEndPickerPresented)
          )
        }
        .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)
    }
  }

  private func serviceCategory(_ viewStore: ViewStoreOf<TrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("Category")
        .formLabel()

      TextField(
        "",
        text: viewStore.binding(\.$serviceCategory)
      )
      .focused($focusedField, equals: .category)
      .formInput(
        placeholder: viewStore.placeholderService.category.rawValue,
        isEmpty: viewStore.serviceCategory.isEmpty,
        isFocused: focusedField == .category
      )
      .synchronize(viewStore.binding(\.$serviceFocusedInput), self.$focusedField)
    }
  }
}

struct TrackView_Previews: PreviewProvider {
  static var previews: some View {
    GradientNoiseBackground().overlay {
      TrackView(
        store: Store(
          initialState: TrackFeature.State(
            placeholderService: TrackFeature.State.popularSubscriptions.randomElement()!,
            serviceSuggestions: [],
            serviceName: "Gihub Copilot",
            serviceCategory: "AI",
            servicePrice: "9.9",
            serviceStartAt: Date().formatted(),
            serviceStartAtDate: Date(),
            serviceEndAt: Date().formatted(),
            serviceEndAtDate: Date(),
            serviceRenewalFrequency: .monthly,
            serviceNameError: nil,
            serviceCategoryError: nil,
            servicePriceError: nil,
            serviceStartAtError: nil,
            serviceEndAtError: nil,
            servicePricePerMonth: "",
            isServiceDateStartPickerPresented: false,
            isServiceDateEndPickerPresented: false,
            serviceFocusedInput: .none
          ),
          reducer: TrackFeature()
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

