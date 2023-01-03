//
//  ProjectsView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 30.12.2022.
//

import SwiftUI

struct ProjectsView: View {

  //MARK: - View Properties
  @EnvironmentObject var dataController: DataController
  @Environment(\.managedObjectContext) var managedObjectContext
  @State private var showingSortOrder = false
  static let openTag: String? = "Open"
  static let closedTag: String? = "Closed"
  var showClosedProjects: Bool
  let projects: FetchRequest<Project>

  //MARK: - View Init
  init(showClosedProjects: Bool) {
    self.showClosedProjects = showClosedProjects

    projects = FetchRequest<Project>(entity: Project.entity(),
                                     sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate,
                                                                        ascending: false)
                                     ],
                                     predicate: NSPredicate(format: "closed = %d",
                                                            showClosedProjects)
    )
  }

  //MARK: - View Body
    var body: some View {
      NavigationView {
        List {
          ForEach(projects.wrappedValue) { project in
            Section(header: Text(project.projectTitle)) {
              ForEach(items(for: project)) { item in
                ItemRowView(item: item)
              }
              .onDelete { offsets in
                let allItems = project.projectItems
                for offset in offsets {
                  let item = allItems[offset]
                  dataController.delete(item)
                }
                dataController.save()
              }
              if showClosedProjects == false {
                Button {
                  withAnimation {
                    let item = Item(context: managedObjectContext)
                    item.project = project
                    item.creationDate = Date()
                    dataController.save()
                  }
                } label: {
                  Label("Add new item", systemImage: "plus")
                }
              }
            }
          }
        }
        .listStyle(.insetGrouped)
        .navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProjects == false {
              Button {
                withAnimation {
                  let project = Project(context: managedObjectContext)
                  project.closed = false
                  project.creationDate = Date()
                  dataController.save()
                }
              } label: {
                Label("Add Project", systemImage: "plus")
              }
            }
          }
          ToolbarItem(placement: .navigationBarLeading) {
            Button {
              showingSortOrder.toggle()
            } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
            }
          }
        }
        .actionSheet(isPresented: $showingSortOrder) {
          ActionSheet(title: Text("Sort Items"), message: nil, buttons: [
            .default(Text("Optimazed")) { },
            .default(Text("Creation Date")) { },
            .default(Text("Title")) { },
          ])
        }
      }
    }

  func items(for project: Project) -> [Item] {
    []
  }
}

struct ProjectsView_Previews: PreviewProvider {
  static var dataController = DataController.preview

    static var previews: some View {
      ProjectsView(showClosedProjects: false)
        .environment(\.managedObjectContext, dataController.container.viewContext)
        .environmentObject(dataController)
    }
}
