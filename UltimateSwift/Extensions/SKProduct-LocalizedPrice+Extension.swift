//
//  SKProduct-LocalizedPrice+Extension.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 27.03.2023.
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
