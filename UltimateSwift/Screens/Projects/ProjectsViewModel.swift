//
//  ProjectsViewModel.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 20.02.2023.
//

import Foundation
import CoreData
import SwiftUI

extension ProjectsView {
  class ViewModel: ObservableObject {

    // MARK: - Properties
    let dataController: DataController
    let projects: FetchRequest<Project>
    var sortOrder = Item.SortOrder.optimazed
    var showClosedProjects: Bool

    // MARK: - Init
    init(dataController: DataController, showClosedProjects: Bool) {
      self.dataController = dataController
      self.showClosedProjects = showClosedProjects

      projects = FetchRequest<Project>(entity: Project.entity(),
                                       sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate,
                                                                          ascending: false)
                                       ],
                                       predicate: NSPredicate(format: "closed = %d",
                                                              showClosedProjects)
      )
    }

    // MARK: - Methods
    func addProject() {
      let project = Project(context: dataController.container.viewContext)
      project.closed = false
      project.creationDate = Date()
      dataController.save()
    }

    func addItem(to project: Project) {
      let item = Item(context: dataController.container.viewContext)
      item.project = project
      item.creationDate = Date()
      dataController.save()
    }

    func delete(_ offsets: IndexSet, from project: Project) {
      let allItems = project.projectItems(using: sortOrder)
      for offset in offsets {
        let item = allItems[offset]
        dataController.delete(item)
      }
      dataController.save()
    }
  }
}
