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
        .tint(Color.theme)
        Spacer()
      }
      .navigationTitle("Date Picker")
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel") {
            showingDatePicker = false
          }
          .foregroundColor(Color.theme)
        }
        ToolbarItem(placement: .confirmationAction) {
          Button("Done") {
            showingDatePicker = false
          }
          .foregroundColor(Color.theme)
        }
      }
    }
  }
}

struct DatePickerView_Previews: PreviewProvider {
  static var previews: some View {
    DatePickerView(date: .constant(Date()), showingDatePicker: .constant(true))
  }
}
