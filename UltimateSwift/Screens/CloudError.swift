//
//  CloudError.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 23.04.2023.
//

import Foundation
import SwiftUI

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
  var id: String { message }
  var message: String
  var localizedMessage: LocalizedStringKey {
      LocalizedStringKey(message)
  }

  init(stringLiteral value: String) {
    self.message = value
  }
}
