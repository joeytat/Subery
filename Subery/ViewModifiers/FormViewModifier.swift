//
//  Form.swift
//  Subery
//
//  Created by yu wang on 2023/5/14.
//

import SwiftUI


extension View {
  func formLabel() -> some View {
    self.modifier(FormLabelModifier())
  }

  func formInput<Prefix: View, Suffix: View>(
    placeholder: String? = nil,
    isEmpty: Bool,
    isFocused: Bool,
    suggestions: [String] = [],
    onSuggestionTapped: @escaping (String) -> Void = { _ in },
    prefix: Prefix? = nil,
    suffix: Suffix? = nil
  ) -> some View  {
    HStack(spacing: 0) {
      prefix
      self.modifier(
        FormInputModifier(
          placeholder: placeholder,
          isEmpty: isEmpty,
          suggestions: suggestions,
          onSuggestionTapped: onSuggestionTapped
        )
      )
      suffix
    }
    .padding()
    .background(Color.daisy.neutral)
    .cornerRadius(10)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(
          isFocused ? Color.daisy.primary : Color.daisy.neutralFocus, lineWidth: 2
        )
    )
  }

  func formInput(
    placeholder: String? = nil,
    isEmpty: Bool,
    isFocused: Bool,
    suggestions: [String] = [],
    onSuggestionTapped: @escaping (String) -> Void = { _ in }
  ) -> some View {
    self.modifier(
      FormInputModifier(
        placeholder: placeholder,
        isEmpty: isEmpty,
        suggestions: suggestions,
        onSuggestionTapped: onSuggestionTapped
      )
    )
    .padding()
    .background(Color.daisy.neutral)
    .cornerRadius(10)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(
          isFocused ? Color.daisy.primary : Color.daisy.neutralFocus, lineWidth: 2
        )
    )
  }

  func formCTAButton() -> some View {
    self.modifier(FormCTAButtonModifier())
  }

  func formError() -> some View {
    self.modifier(FormErrorModifier())
  }

}

struct FormLabelModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .foregroundColor(Color.daisy.infoContent)
  }
}

struct FormInputModifier: ViewModifier {
  let placeholder: String?
  let isEmpty: Bool
  let suggestions: [String]
  let onSuggestionTapped: (String) -> Void

  func body(content: Content) -> some View {
    VStack(spacing: 0) {
      content
        .font(.body)
        .tint(.daisy.infoContent)
        .accentColor(Color.daisy.primaryContent)
        .foregroundColor(Color.daisy.neutralContent)
        .overlay(
          HStack {
            if let placeholder, isEmpty {
              Text(placeholder)
                .foregroundColor(Color.daisy.secondary)
                .font(.body)
              Spacer()
            }
          }.allowsHitTesting(false)
        )

      if !suggestions.isEmpty {
        ScrollView {
          VStack {
            ForEach(suggestions, id: \.self) { suggestion in
              VStack(alignment: .leading) {
                Divider()
                  .foregroundColor(Color.daisy.secondaryFocus)
                Button {
                  onSuggestionTapped(suggestion)
                } label: {
                  Text(suggestion)
                    .font(.callout)
                    .frame(height: 30)
                    .foregroundColor(Color.daisy.secondaryFocus)
                }
              }
              .transition(.slide)
              .animation(.spring(), value: suggestions)
            }
          }
          .padding(.leading)
        }
        .frame(
          maxHeight: .minimum(
            50 * CGFloat(suggestions.count), 150
          )
        )
      }
    }
  }

}

struct FormCTAButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .padding(.horizontal, Theme.spacing.lg)
      .padding(.vertical, Theme.spacing.md)
      .foregroundColor(Color.daisy.primaryContent)
      .background(Color.daisy.primary)
      .cornerRadius(10)
  }
}

struct FormErrorModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.caption)
      .foregroundColor(Color.daisy.error)
  }
}


