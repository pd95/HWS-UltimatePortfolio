//
//  SKProduct-LocalizedPrice.swift
//  UltimatePortfolio
//
//  Created by Philipp on 04.07.21.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
