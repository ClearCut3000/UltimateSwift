//
//  SceneDelegate.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 30.03.2023.
//

import SwiftUI

class SceneDelegate: NSObject, UIWindowSceneDelegate {

  @Environment(\.openURL) var openURL

  func windowScene(_ windowScene: UIWindowScene,
                   performActionFor shortcutItem: UIApplicationShortcutItem,
                   completionHandler: @escaping (Bool) -> Void) {
    guard let url = URL(string: shortcutItem.type) else {
      completionHandler(false)
      return
    }
    openURL(url, completion: completionHandler)
  }

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    if let shortcutItem = connectionOptions.shortcutItem {
      guard let url = URL(string: shortcutItem.type) else { return }
      openURL(url)
    }
  }
}
