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
  class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {

    // MARK: - Properties
    let dataController: DataController
    var sortOrder = Item.SortOrder.optimized
    var showClosedProjects: Bool
    private let projectsController: NSFetchedResultsController<Project>
    @Published var projects = [Project]()
    @Published var showingUnlockView = false
    @Published var selectedItem: Item?

    // MARK: - Init
    init(dataController: DataController, showClosedProjects: Bool) {
      self.dataController = dataController
      self.showClosedProjects = showClosedProjects
      /// create an NSFetchRequest that loads data
      let request: NSFetchRequest<Project> = Project.fetchRequest()
      request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate,
                                                  ascending: false)]
      request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)
      /// wrap that NSFetchRequest in an NSFetchedResultsController
      projectsController = NSFetchedResultsController(fetchRequest: request,
                                                      managedObjectContext: dataController.container.viewContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil)
      /// set the view model class as the delegate of the fetched results controller
      /// so that it can tell when the data has changed somehow
      super.init()
      projectsController.delegate = self
      do {
        try projectsController.performFetch()
        projects = projectsController.fetchedObjects ?? []
      } catch {
        print("Failed to fetch projects!")
      }
    }

    // MARK: - Methods
    func addProject() {
      if dataController.addProject() == false {
        showingUnlockView.toggle()
      }
    }

    func addItem(to project: Project) {
      let item = Item(context: dataController.container.viewContext)
      item.project = project
      item.priority = 2
      item.completed = false
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

    func delete(_ item: Item) {
      dataController.delete(item)
      dataController.save()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      if let newProjects = controller.fetchedObjects as? [Project] {
        projects = newProjects
      }
    }
  }
}
