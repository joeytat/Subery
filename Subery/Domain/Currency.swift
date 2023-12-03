//
//  Currency.swift
//  Subery
//
//  Created by yu wang on 2023/7/4.
//

import Foundation

struct Currency: Equatable, Identifiable, Hashable {
  var id: String { identifier }
  let identifier: String
  let symbol: String

  var display: String {
    "\(identifier)\(symbol)"
  }

  static var current: Currency {
    Currency(
      identifier: Locale.current.currency?.identifier ?? "USD",
      symbol: Locale.current.currencySymbol ?? "$"
    )
  }

  static var all: [Currency] {
    [
      "en-US",
      "zh-CN"
    ]
      .map { identifier in
        let locale = Locale(identifier: identifier)
        return Currency(identifier: locale.currency!.identifier, symbol: locale.currencySymbol!)
      }
  }
}
