//
//  CloudError.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 23.04.2023.
//

import Foundation

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
  var id: String { message }
  var message: String

  init(stringLiteral value: String) {
    self.message = value
  }
}
