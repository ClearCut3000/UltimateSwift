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
  var rows: [GridItem] {
    [GridItem(.fixed(100))]
  }

  //MARK: - View Init
  init() {
    let request: NSFetchRequest<Item> = Item.fetchRequest()
    request.predicate = NSPredicate(format: "completed = false")
    request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority,
                                                ascending: false)]
    request.fetchLimit = 10
    items = FetchRequest(fetchRequest: request)
  }

  //MARK: - View Body
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows) {
              ForEach(projects) { project in
                VStack(alignment: .leading) {
                  Text("\(project.projectItems.count) items")
                    .font(.caption)
                    .foregroundColor(.secondary)
                  Text(project.projectTitle)
                    .font(.title2)
                  ProgressView(value: project.completionAmount)
                    .accentColor(Color(project.projectColor))
                }
                .padding()
                .background(Color.secondarySystemGroupedBackground)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(project.label)
              }
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
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
