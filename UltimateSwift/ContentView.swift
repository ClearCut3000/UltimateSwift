//
//  ContentView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 21.12.2022.
//

import SwiftUI

struct ContentView: View {

  // MARK: - View Properties
  @SceneStorage("selectedView") var selectedView: String?
  @EnvironmentObject var dataController: DataController

  // MARK: - View Body
  var body: some View {
    TabView(selection: $selectedView) {
      HomeView(dataController: dataController)
        .tag(HomeView.tag)
        .tabItem {
          Image(systemName: "house")
          Text("Home")
        }
      ProjectsView(dataController: dataController, showClosedProjects: false)
        .tag(ProjectsView.openTag)
        .tabItem {
          Image(systemName: "list.bullet")
          Text("Open")
        }
      ProjectsView(dataController: dataController, showClosedProjects: true)
        .tag(ProjectsView.closedTag)
        .tabItem {
          Image(systemName: "checkmark")
          Text("Closed")
        }
      AwardsView()
        .tag(AwardsView.tag)
        .tabItem {
          Image(systemName: "rosette")
          Text("Awards")
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var dataController = DataController.preview

  static var previews: some View {
    ContentView()
      .environment(\.managedObjectContext, dataController.container.viewContext)
      .environmentObject(dataController)
  }
}
