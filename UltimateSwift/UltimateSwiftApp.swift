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
  @StateObject var dataController: DataController

  // MARK: - Init
  init() {
    let dataController = DataController()
    _dataController = StateObject(wrappedValue: dataController)
  }

  // MARK: - Body
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                   perform: save(_:))
    }
  }

  // MARK: - Methods
  func save(_ note: Notification) {
    dataController.save()
  }
}
