//
//  CustomSheet.swift
//  Subery
//
//  Created by yu wang on 2023/5/4.
//

import SwiftUI

struct CustomSheet<Content: View>: View {
  @Binding var isPresented: Bool
  let content: () -> Content

  var body: some View {
    ZStack {
      if isPresented {
        GradientNoiseBackground()
          .edgesIgnoringSafeArea(.all)
          .onTapGesture {
            withAnimation {
              isPresented = false
            }
          }

        content()
      }
    }
    .opacity(isPresented ? 1 : 0)
    .animation(.easeInOut(duration: 0.3), value: isPresented)
  }
}

extension View {
  func customSheet<Content: View>(
    isPresented: Binding<Bool>,
    content: @escaping () -> Content
  ) -> some View {
    self
      .overlay(
        CustomSheet(isPresented: isPresented, content: content)
          .edgesIgnoringSafeArea(.all)
      )
  }
}
