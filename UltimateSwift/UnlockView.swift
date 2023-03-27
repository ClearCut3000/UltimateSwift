//
//  UnlockView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 27.03.2023.
//

import SwiftUI
import StoreKit

struct UnlockView: View {

  // MARK: - View Properties
  @Environment(\.presentationMode) var presentationMode
  @EnvironmentObject var unlockManager: UnlockManager

  // MARK: - View Body
  var body: some View {
    VStack {
      switch unlockManager.requestState {
      case .loaded(let product):
        ProductView(product: product)
      case .failed(_):
        Text("Sorry, there was an error loading the store. Please try again later.")
      case .loading:
        ProgressView("Loading…")
      case .purchased:
        Text("Thank you!")
      case .deferred:
        Text("Thank you! Your request is pending approval, but you can carry on using the app in the meantime.")
      }
      Button("Dismiss", action: dismiss)
    }
    .padding()
    .onReceive(unlockManager.$requestState) { value in
      if case .purchased = value {
        dismiss()
      }
    }
  }

  // MARK: - View Properties
  func dismiss() {
    presentationMode.wrappedValue.dismiss()
  }
}
