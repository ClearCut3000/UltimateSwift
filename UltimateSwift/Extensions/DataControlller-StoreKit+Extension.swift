//
//  DataControlller-StoreKit+Extension.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 07.04.2023.
//

import Foundation
import StoreKit

extension DataController {
  /// Called when the app is launched to find the first active scene
  func appLaunched() {
    guard count(for: Project.fetchRequest()) >= 5 else { return }
    let allScenes = UIApplication.shared.connectedScenes
    let scene = allScenes.first { $0.activationState == .foregroundActive }
    if let windowScene = scene as? UIWindowScene {
      SKStoreReviewController.requestReview(in: windowScene)
    }
  }
}
