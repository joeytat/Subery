//
//  Date+.swift
//  Subery
//
//  Created by yu wang on 2023/5/4.
//

import Foundation

extension Date {
    func format(
        config: (DateFormatter) -> Void = { formatter in
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
        }
    ) -> String {
        let dateFormatter = DateFormatter()
        config(dateFormatter)
        return dateFormatter.string(from: self)
    }

    func startOfDay() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }

    func nextMonth() -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: 1, to: self)!
    }

}
