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

  func formContainer() -> some View {
    self.modifier(FormContainerModifier())
  }

  func formCTAButton() -> some View {
    self.modifier(FormCTAButtonModifier())
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
  func body(content: Content) -> some View {
    content
      .background(Color.white)
      .cornerRadius(10)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.theme, lineWidth: 2)
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

