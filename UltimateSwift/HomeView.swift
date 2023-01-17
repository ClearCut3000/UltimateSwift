//
//  HomeView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 30.12.2022.
//

import CoreData
import SwiftUI

struct HomeView: View {

  //MARK: - View Properties
  static let tag: String? = "Home"
  @EnvironmentObject var dataController: DataController
  @FetchRequest(entity: Project.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Project.title,
                                                   ascending: true)],
                predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
  let items: FetchRequest<Item>

  //MARK: - View Init
  init() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    request.predicate = NSPredicate(format: "closed = false")
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority,
                                               ascending: false)]
    request.fetchLimit = 10
    items = FetchRequest(fetchRequest: request)
  }

  //MARK: - View Body
  var body: some View {
    NavigationView {
      ScrollView {

      }
      .background(Color.systemGroupedBackground.ignoresSafeArea())
      .navigationTitle("Home")
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
