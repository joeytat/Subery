//
//  TrackView.swift
//  Subery
//
//  Created by yu wang on 2023/5/2.
//

import SwiftUI
import ComposableArchitecture
import Combine

struct AddTrackView: View {
  let store: StoreOf<AddTrackFeature>
  @FocusState var focusedField: AddTrackFeature.State.Field?

  var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Form {
        VStack(spacing: Theme.spacing.xl) {
          serviceName(viewStore)
          serviceCategory(viewStore)
          servicePrice(viewStore)
          Section {
            HStack(spacing: Theme.spacing.lg) {
              serviceStartAt(viewStore)
              serviceEndAt(viewStore)
            }
          }
        }
        .padding(.top, Theme.spacing.sm)

        Spacer()
      }
      .formStyle(.columns)
      .bind(viewStore.$serviceFocusedInput, to: self.$focusedField)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            viewStore.send(.onCancelButtonTapped)
          } label: {
            Image(systemName: "chevron.backward")
              .foregroundColor(Color.white)
              .font(.title3)
              .fontWeight(.semibold)
          }
        }
        ToolbarItem(placement: .principal) {
          Text("Add Track")
            .foregroundColor(Color.white)
            .font(.title2)
            .fontWeight(.bold)
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            viewStore.send(.onSaveButtonTapped)
          } label: {
            Image(systemName: "square.and.arrow.down.fill")
              .foregroundColor(Color.daisy.accent)
              .font(.title3)
              .fontWeight(.semibold)
          }
        }
      }
    }
    .padding(.horizontal, Theme.spacing.md)
    .background(GradientBackgroundView())
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden()
  }

  private func serviceName(_ viewStore: ViewStoreOf<AddTrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("App / Service Name")
        .formLabel()

      TextField(
        "",
        text: viewStore.binding(get: \.track.name, send: { .setName($0) })
      )
      .focused($focusedField, equals: .name)
      .formInput(
        placeholder: viewStore.placeholderService.name,
        isEmpty: viewStore.track.name.isEmpty,
        isFocused: focusedField == .name,
        suggestions: viewStore.state.serviceSuggestions.map { $0.name },
        onSuggestionTapped: { suggestion in
          viewStore.send(.setName(suggestion))
        }
      )
      .padding(
        .bottom, viewStore.state.serviceSuggestions.isEmpty ? 0 : Theme.spacing.sm
      )

      if let error = viewStore.serviceNameError {
        Text(error)
          .formError()
          .padding(.leading)
      }
    }
  }

  private func servicePrice(_ viewStore: ViewStoreOf<AddTrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("Price")
        .formLabel()

      TextField(
        "",
        text: viewStore.binding(get: \.track.price, send: { .setPrice($0) })
      )
      .keyboardType(.numberPad)
      .focused($focusedField, equals: .price)
      .formInput(
        isEmpty: viewStore.track.name.isEmpty,
        isFocused: focusedField == .price,
        prefix: (
          Dropdown(label: {
            Text(viewStore.track.currency.display)
              .underline()
              .foregroundColor(Color.daisy.neutralContent)
              .font(.body)
              .padding(.trailing, Theme.spacing.ssm)
          }) {
            ForEach(Currency.all, id: \.self) { currency in
              Button(action: {
                viewStore.send(.setCurrency(currency))
              }) {
                HStack {
                  Text(currency.display)
                    .formLabel()
                  if currency == viewStore.track.currency {
                    Image(systemName: "checkmark.square.fill")
                  }
                }
              }
            }
          }
        ),
        suffix: (
          Dropdown(label: {
            HStack {
              Text(viewStore.track.renewalFrequency.rawValue)
                .foregroundColor(Color.daisy.neutralContent)
              Image(systemName: "chevron.down")
                .foregroundColor(Color.daisy.neutralContent)
            }
          }) {
            ForEach(Track.RenewalFrequency.allCases, id: \.self) { option in
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

  private func serviceStartAt(_ viewStore: ViewStoreOf<AddTrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("Start at")
        .formLabel()

      HStack {
        Text(viewStore.track.startAtDate, style: .date)
        Spacer()
      }
      .formInput(
        placeholder: Date().format(),
        isEmpty: false,
        isFocused: focusedField == .startAt
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
            date: viewStore.binding(
              get: \.track.startAtDate,
              send: { .setStartAt($0) }
            ),
            setDatePicker: { viewStore.send(.setServiceDateStartPickerPresented(isPresented: $0)) }
          )
        }
      )
    }
  }

  private func serviceEndAt(_ viewStore: ViewStoreOf<AddTrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("End at")
        .formLabel()

      HStack {
        Text(viewStore.track.endAtDate, style: .date)
        Spacer()
      }
      .formInput(
        placeholder: Date().format(),
        isEmpty: false,
        isFocused: focusedField == .endAt
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
            date: viewStore.binding(
              get: \.track.endAtDate,
              send: { .setEndAt($0) }
            ),
            setDatePicker: { viewStore.send(.setServiceDateEndPickerPresented(isPresented: $0)) }
          )
        }
      )
    }
  }

  private func serviceCategory(_ viewStore: ViewStoreOf<AddTrackFeature>) -> some View {
    VStack(alignment: .leading) {
      Text("Category")
        .formLabel()

      TextField(
        "",
        text: viewStore.binding(
          get: \.track.category,
          send: { .setCategory($0) }
        )
      )
      .focused($focusedField, equals: .category)
      .formInput(
        placeholder: viewStore.placeholderService.category.rawValue,
        isEmpty: viewStore.track.category.isEmpty,
        isFocused: focusedField == .category
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
  var focusState: FocusState<AddTrackFeature.State.Field?>.Binding

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

