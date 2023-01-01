//
//  Binding-onChange+Extension.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 01.01.2023.
//

import SwiftUI

extension Binding {
  func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
    Binding {
      self.wrappedValue
    } set: { newValue in
      self.wrappedValue = newValue
      handler()
    }
  }
}
