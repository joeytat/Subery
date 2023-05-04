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
    if isPresented {
      ZStack {
        GradientNoiseBackground()
          .edgesIgnoringSafeArea(.all)
          .onTapGesture {
            withAnimation {
              isPresented = false
            }
          }

        content()
          .transition(.opacity.combined(with: .move(edge: .bottom)))
          .animation(.easeInOut(duration: 0.3), value: isPresented)
      }
    } else {
      EmptyView()
    }
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
