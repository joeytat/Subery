//
//  Standup.swift
//  Subery
//
//  Created by yu wang on 2023/12/3.
//

import Foundation

struct Track: Equatable, Identifiable {
  let id: UUID
  var name: String = ""
  var category: String = ""
  var price: String = ""
  var startAtDate: Date = Date()
  var endAtDate: Date = Date()
  var renewalFrequency: RenewalFrequency = .monthly
  var currency: Currency = .current
}

extension Track {
  enum RenewalFrequency: String, CaseIterable {
    case monthly = "Monthly"
    case quarterly = "Quarterly"
    case yearly = "Yearly"
  }
}

extension Track {
  static let mock = Self(
    id: Track.ID(),
    name: "Github Copilot",
    category: "AI",
    price: "9.9",
    startAtDate: .now,
    endAtDate: .distantFuture,
    renewalFrequency: .monthly,
    currency: .current
  )
}
