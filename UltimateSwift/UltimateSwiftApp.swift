//
//  UltimateSwiftApp.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 21.12.2022.
//

import SwiftUI

@main
struct UltimateSwiftApp: App {

  @StateObject var dataController: DataController

  init() {
    let dataController = DataController()
    _dataController = StateObject(wrappedValue: dataController)
  }

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
        }
    }
}
