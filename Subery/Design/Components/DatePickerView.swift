//
//  DatePickerView.swift
//  Subery
//
//  Created by yu wang on 2023/5/4.
//

import SwiftUI
import ComposableArchitecture

struct DatePickerView: View {
    @Binding var date: Date
    var setDatePicker: (Bool) -> Void

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(
                    "form.datePicker",
                    selection: $date,
                    displayedComponents: [.date]
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .labelsHidden()
                .padding()
                .tint(Color.daisy.accentInvert)
                Spacer()
            }
            .tint(Color.daisy.neutralContent)
            .colorInvert()
            .background(Color.daisy.neutral)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        setDatePicker(false)
                    }
                    .foregroundColor(Color.daisy.neutralContent)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        setDatePicker(false)
                    }
                    .foregroundColor(Color.daisy.neutralContent)
                }
            }
        }
    }
}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(date: .constant(Date()), setDatePicker: { _ in })
    }
}
