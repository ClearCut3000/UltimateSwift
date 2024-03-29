//
//  ContentView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 21.12.2022.
//

import SwiftUI
import CoreSpotlight

struct ContentView: View {

  // MARK: - View Properties
  @SceneStorage("selectedView") var selectedView: String?
  @EnvironmentObject var dataController: DataController
  private let neewProjectActivity = "com.example.UltimateSwift.newProject"

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
      SharedProjectsView()
        .tag(SharedProjectsView.tag)
        .tabItem {
          Image(systemName: "person.3")
          Text("Community")
        }
    }
    .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
    .onContinueUserActivity(neewProjectActivity, perform: createProject(_:))
    .onOpenURL(perform: openURL)
    .userActivity(neewProjectActivity) { activity in
      activity.title = "New Project"
#if os(iOS) || os(watchOS)
      activity.isEligibleForPrediction = true
#endif
    }
  }

  // MARK: - View Methods
  func moveToHome(_ input: Any) {
    selectedView = HomeView.tag
  }

  func openURL(_ url: URL) {
    selectedView = ProjectsView.openTag
    _ = dataController.addProject()
  }

  func createProject(_ userActivity: NSUserActivity) {
    selectedView = ProjectsView.openTag
    _ = dataController.addProject()
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
