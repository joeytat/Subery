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
    var endAtDate: Date = Date().nextMonth()
    var renewalFrequency: RenewalFrequency = .monthly
    var currency: Currency = .current
    
    var priceDescription: String? {
        guard let deformattedPriceValue = Float(price)?.roundedToDecimalPlaces(), deformattedPriceValue > 0 else {
            return nil
        }
        switch renewalFrequency {
        case .monthly:
            return nil
        case .quarterly:
            return "\((deformattedPriceValue / 4).roundedToDecimalPlaces())"
        case .yearly:
            return "\((deformattedPriceValue / 12).roundedToDecimalPlaces())"
        }
    }
}

extension Track {
    enum RenewalFrequency: String, CaseIterable {
        case monthly = "form.cycle.monthly"
        case quarterly = "form.cycle.quarterly"
        case yearly = "form.cycle.yearly"
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
