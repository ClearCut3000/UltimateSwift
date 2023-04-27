//
//  PlatformAdjustments.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 25.04.2023.
//

import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
  static let willResignActive = UIApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationView(content: content)
            .navigationViewStyle(.stack)
    }
}
