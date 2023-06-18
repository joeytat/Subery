//
//  DatePickerView.swift
//  Subery
//
//  Created by yu wang on 2023/5/4.
//

import SwiftUI

struct DatePickerView: View {
  @Binding var date: Date
  @Binding var showingDatePicker: Bool

  var body: some View {
    NavigationView {
      VStack {
        DatePicker(
          "Select a date",
          selection: $date,
          displayedComponents: [.date]
        )
        .datePickerStyle(GraphicalDatePickerStyle())
        .labelsHidden()
        .padding()
        .tint(Color.daisy.warning)
        .colorMultiply(Color.daisy.infoContent)
        .colorInvert()
        Spacer()
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            showingDatePicker = false
          }
          .foregroundColor(Color.daisy.neutralContent)
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            showingDatePicker = false
          }
          .foregroundColor(Color.daisy.neutralContent)
        }
      }
      .background(Color.daisy.neutral)
    }
  }
}

struct DatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    DatePickerView(date: .constant(Date()), showingDatePicker: .constant(true))
  }
}
