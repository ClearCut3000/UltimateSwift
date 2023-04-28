//
//  PlatformAdjustments.swift
//  UltimateSwiftMac
//
//  Created by Николай Никитин on 25.04.2023.
//

import SwiftUI

/// Extension for replasing iOS grouped list style to default on macOS
typealias InsetGroupedListStyle = DefaultListStyle

/// extension for using BorderlessButtonStyle to make Awards buttons look fine
typealias ImageButtonStyle = BorderlessButtonStyle

/// For using regular spacer on macOS
typealias MacOnlySpacer = Spacer

/// extension for access to notification on macOS
extension Notification.Name {
  static let willResignActive = NSApplication.willResignActiveNotification
}

/// New view type that can render as a NavigationView on iOS, or as a simple VStack on macOS
///  allowing to recreate the behavior of the .stack navigation view style across both platform.
struct StackNavigationView<Content: View>: View {
  @ViewBuilder let content: () -> Content

  var body: some View {
    VStack(spacing: 0, content: content)
  }
}

/// Extension for disabling collapsible sections on macOS
extension Section where Parent: View, Content: View, Footer: View {
  func disableCollapsing() -> some View {
    self.collapsible(false)
  }
}

/// For using padding on macOS
extension View {
  func macOnlyPadding() -> some View {
    self.padding()
  }
}
