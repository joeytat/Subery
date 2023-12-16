//
//  TrackView.swift
//  Subery
//
//  Created by yu wang on 2023/5/2.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct TrackFormView: View {
  let store: StoreOf<TrackFormFeature>
  @FocusState var focus: TrackFormFeature.State.Field?

  var body: some View {
    WithViewStore(self.store, observe: { $0 }) { viewStore in
      Form {
        Section {
          VStack(alignment: .leading) {
            Text("App / Service Name")
              .formLabel()

            TextField("App / Service Name", text: viewStore.$track.name)
              .focused($focus, equals: .name)
              .formInput(
                placeholder: viewStore.placeholderService.name,
                isEmpty: viewStore.track.name.isEmpty,
                isFocused: focus == .name,
                suggestions: viewStore.serviceSuggestions.map { $0.name },
                onSuggestionTapped: { _ in
                  //          viewStore.send(.setName(suggestion))
                }
              )
              .padding(
                .bottom, viewStore.serviceSuggestions.isEmpty ? 0 : Theme.spacing.sm
              )

            if let error = viewStore.serviceNameError {
              Text(error)
                .formError()
                .padding(.leading)
            }
          }
        }

        Section {
          VStack(alignment: .leading) {
            Text("Category")
              .formLabel()

            TextField("", text: viewStore.$track.category)
              .focused($focus, equals: .category)
              .formInput(
                placeholder: viewStore.placeholderService.category.rawValue,
                isEmpty: viewStore.track.category.isEmpty,
                isFocused: focus == .category
              )
          }
        }

        Section {
          VStack(alignment: .leading) {
            Text("Price")
              .formLabel()

            TextField("", text: viewStore.$track.price)
              .keyboardType(.numberPad)
              .focused($focus, equals: .price)
              .formInput(
                isEmpty: viewStore.track.price.isEmpty,
                isFocused: focus == .price,
                prefix: currencyDropdown(viewStore.$track.currency),
                suffix: renewalFrequencyDropdown(viewStore.$track.renewalFrequency)
              )

            if let priceDescription = viewStore.track.priceDescription {
              Text(priceDescription)
                .font(.callout)
                .foregroundColor(Color.daisy.infoContent)
                .padding(.leading)
            }

            if let error = viewStore.servicePriceError {
              Text(error)
                .formError()
                .padding(.leading)
            }
          }
        }

        Section {
          HStack(spacing: Theme.spacing.lg) {
            VStack(alignment: .leading) {
              Text("Start at")
                .formLabel()

              HStack {
                Text(viewStore.track.startAtDate.format())
                Spacer()
              }
              .formInput(
                placeholder: Date().format(),
                isEmpty: false,
                isFocused: focus == .startAt
              )
              .onTapGesture {
                viewStore.send(.setServiceDateStartPickerPresented(isPresented: true))
              }
              .sheet(
                isPresented: viewStore.binding(
                  get: \.isServiceDateStartPickerPresented,
                  send: { .setServiceDateStartPickerPresented(isPresented: $0) }),
                content: {
                  DatePickerView(
                    date: viewStore.$track.startAtDate,
                    setDatePicker: { viewStore.send(.setServiceDateStartPickerPresented(isPresented: $0)) }
                  )
                }
              )
            }

            VStack(alignment: .leading) {
              Text("End at")
                .formLabel()

              HStack {
                Text(viewStore.track.endAtDate.format())
                Spacer()
              }
              .formInput(
                placeholder: Date().format(),
                isEmpty: false,
                isFocused: focus == .endAt
              )
              .onTapGesture {
                viewStore.send(.setServiceDateEndPickerPresented(isPresented: true))
              }
              .sheet(
                isPresented: viewStore.binding(
                  get: \.isServiceDateEndPickerPresented,
                  send: { .setServiceDateEndPickerPresented(isPresented: $0) }),
                content: {
                  DatePickerView(
                    date: viewStore.$track.endAtDate,
                    setDatePicker: { viewStore.send(.setServiceDateEndPickerPresented(isPresented: $0)) }
                  )
                }
              )
            }
          }
        }
        .padding(.top, Theme.spacing.sm)
        Spacer()
      }
      .formStyle(.columns)
      .bind(viewStore.$focus, to: self.$focus)
    }
    .padding(.horizontal)
    .background(GradientBackgroundView())
  }

  private func currencyDropdown(
    _ selectedCurrency: Binding<Currency>
  ) -> some View {
    Dropdown(
      label: {
        Text(selectedCurrency.wrappedValue.display)
          .underline()
          .foregroundColor(Color.daisy.neutralContent)
          .font(.body)
          .padding(.trailing, Theme.spacing.ssm)
      }) {
        ForEach(Currency.all, id: \.self) { currency in
          Button(action: {
            selectedCurrency.wrappedValue = currency
          }) {
            HStack {
              Text(currency.display)
                .formLabel()
              if currency == selectedCurrency.wrappedValue {
                Image(systemName: "checkmark.square.fill")
              }
            }
          }
        }
      }
  }

  private func renewalFrequencyDropdown(
    _ selectedFrequency: Binding<Track.RenewalFrequency>
  ) -> some View {
    Dropdown(
      label: {
        HStack {
          Text(selectedFrequency.wrappedValue.rawValue)
            .foregroundColor(Color.daisy.neutralContent)
          Image(systemName: "chevron.down")
            .foregroundColor(Color.daisy.neutralContent)
        }
      }) {
        ForEach(Track.RenewalFrequency.allCases, id: \.self) { option in
          Button(action: {
            selectedFrequency.wrappedValue = option
          }) {
            HStack {
              Text(option.rawValue)
                .formLabel()

              if option == selectedFrequency.wrappedValue {
                Image(systemName: "checkmark.square.fill")
              }
            }
          }
        }
      }
  }
}

struct PriceTextField: View {
  let prefix: String
  let suffix: String
  let placeholder: String
  let keyboardType: UIKeyboardType

  @Binding var text: String
  var focusState: FocusState<TrackFormFeature.State.Field?>.Binding

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

#Preview {
  TrackFormView(
    store: .init(
      initialState: TrackFormFeature.State(
        track: .init(id: UUID())
      ),
      reducer: {
        TrackFormFeature()
      }
    )
  )
}
