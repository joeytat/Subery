//
//  Form.swift
//  Subery
//
//  Created by yu wang on 2023/5/14.
//

import SwiftUI

struct FormLabelModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.headline)
      .foregroundColor(Color.lightGray)
  }
}

extension View {
  func formLabel() -> some View {
    self.modifier(FormLabelModifier())
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

extension View {
  func formContainer() -> some View {
    self.modifier(FormContainerModifier())
  }
}
