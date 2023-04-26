//
//  UltimateSwiftApp.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 21.12.2022.
//

import SwiftUI

@main
struct UltimateSwiftApp: App {

  // MARK: - Properties
#if os(iOS)
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
  @StateObject var dataController: DataController
  @StateObject var unlockManager: UnlockManager

  // MARK: - Init
  init() {
    let dataController = DataController()
    let unlockManager = UnlockManager(dataController: dataController)
    _dataController = StateObject(wrappedValue: dataController)
    _unlockManager = StateObject(wrappedValue: unlockManager)
#if targetEnvironment(simulator)
    UserDefaults.standard.set("ClearCut3000", forKey: "username")
#endif
  }

  // MARK: - Body
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
        .environmentObject(unlockManager)
        .onReceive(
          // Automatically save when we detect that we are
          // no longer the foreground app. Use this rather than
          // scene phase so we can port to macOS, where scene
          // phase won't detect our app losing focus.
          NotificationCenter.default.publisher(for: .willResignActive),
          perform: save(_:))
        .onAppear(perform: dataController.appLaunched)
    }
  }

  // MARK: - Methods
  func save(_ note: Notification) {
    dataController.save()
  }
}
