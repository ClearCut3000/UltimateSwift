//
//  PlatformAdjustments.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 25.04.2023.
//

import SwiftUI

/// extension for using BorderlessButtonStyle to make Awards buttons look fine
typealias ImageButtonStyle = BorderlessButtonStyle

/// extension for access to notification on iOS
extension Notification.Name {
  static let willResignActive = UIApplication.willResignActiveNotification
}

/// New view type that can render as a NavigationView on iOS, or as a simple VStack on macOS
///  allowing to recreate the behavior of the .stack navigation view style across both platform.
struct StackNavigationView<Content: View>: View {
  @ViewBuilder let content: () -> Content

  var body: some View {
    NavigationView(content: content)
      .navigationViewStyle(.stack)
  }
}

/// extension for iOS platform to make collapsible modifier been ignored and compiled
extension Section where Parent: View, Content: View, Footer: View {
  func disableCollapsing() -> some View {
    self
  }
}

/// extension for iOS to make onDeleteCommand been ignored and compiled
extension View {
  func onDeleteCommand(perform action: (() -> Void)?) -> some View {
    self
  }
  /// inner modifier for do-nothing on iOS
  func macOnlyPadding() -> some View {
    self
  }
}

/// For using regular spacer on macOS and to be ignored on iOS
typealias MacOnlySpacer = EmptyView
