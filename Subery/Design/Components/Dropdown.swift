//
//  Dropdown.swift
//  Subery
//
//  Created by yu wang on 2023/5/5.
//

import SwiftUI

struct Dropdown<Label: View, Content: View>: View {
  let label: Label
  let content: Content

  init(@ViewBuilder label: () -> Label, @ViewBuilder content: () -> Content) {
    self.label = label()
    self.content = content()
  }

  var body: some View {
    Menu {
      content
    } label: {
      label
    }
  }
}


struct Dropdown_Previews: PreviewProvider {
  static var previews: some View {
    Dropdown(label: {
      Text("Label")
    }, content: {
      Text("Content")
    })
  }
}
