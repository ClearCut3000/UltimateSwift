//
//  PurchaseButton.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 27.03.2023.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(minWidth: 200, minHeight: 44)
      .background(Color("Light Blue"))
      .clipShape(Capsule())
      .foregroundColor(.white)
      .opacity(configuration.isPressed ? 0.5 : 1)
  }
}
