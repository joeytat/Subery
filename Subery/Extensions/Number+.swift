//
//  Number+.swift
//  Subery
//
//  Created by yu wang on 2023/5/14.
//

import Foundation

extension Float {
    func roundedToDecimalPlaces(_ decimalPlaces: Int = 2) -> Float {
        let multiplier = pow(10, Float(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
}
