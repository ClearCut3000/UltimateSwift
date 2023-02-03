//
//  HomeView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 30.12.2022.
//

import CoreData
import SwiftUI

struct HomeView: View {

  // MARK: - View Properties
  static let tag: String? = "Home"
  @EnvironmentObject var dataController: DataController
  @FetchRequest(entity: Project.entity(),
                sortDescriptors: [NSSortDescriptor(keyPath: \Project.title,
                                                   ascending: true)],
                predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
  let items: FetchRequest<Item>
  var rows: [GridItem] {
    [GridItem(.fixed(100))]
  }

  // MARK: - View Init
  init() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    let completedPredicate = NSPredicate(format: "completed = false")
    let opedPredicate = NSPredicate(format: "project.closed = false")
    let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, opedPredicate])
    request.predicate = completedPredicate
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority,
                                                ascending: false)]
    request.fetchLimit = 10
    items = FetchRequest(fetchRequest: request)
  }

  // MARK: - View Body
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows) {
              ForEach(projects, content: ProjectSummaryView.init)
            }
            .padding([.horizontal, .top])
            .fixedSize(horizontal: false, vertical: true)
          }
          VStack(alignment: .leading) {
            ItemListView(title: "Up next", items: items.wrappedValue.prefix(3))
            ItemListView(title: "More to explore", items: items.wrappedValue.dropFirst(3))
          }
          .padding(.horizontal)
        }
      }
      .background(Color.systemGroupedBackground.ignoresSafeArea())
      .navigationTitle("Home")
      .toolbar {
        Button("Add Sample Data") {
          dataController.deleteAll()
          try? dataController.createSampleData()
        }
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
