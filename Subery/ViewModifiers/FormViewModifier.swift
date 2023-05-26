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

  func formInput() -> some View {
    self.modifier(FormInputModifier())
  }

  func formContainer(_ state: FormContainerModifier.State) -> some View {
    self.modifier(FormContainerModifier(state: state))
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
      .foregroundColor(Color.lightGray)
  }
}

struct FormInputModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.body)
      .padding()
  }
}

struct FormContainerModifier: ViewModifier {
  enum State {
    case normal
    case error
  }

  let state: State

  func body(content: Content) -> some View {
    content
      .background(Color.white)
      .cornerRadius(10)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(state == .normal ? Color.theme : Color.error, lineWidth: 2)
      )
  }
}

struct FormCTAButtonModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .foregroundColor(Color.dark)
      .bevelStyle()
  }
}

struct FormErrorModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.caption)
      .foregroundColor(Color.error)
  }
}


