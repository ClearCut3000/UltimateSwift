//
//  HomeViewModel.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 09.03.2023.
//

import CoreData
import Foundation

extension HomeView {
  class HomeModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    private let projectsController: NSFetchedResultsController<Project>
    private let itemsController: NSFetchedResultsController<Item>

    @Published var projects = [Project]()
    @Published var items = [Item]()

    init(dataController: DataController) {
      self.dataController = dataController

      // Construct a fetch request to show all open projects.
      let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
      projectRequest.predicate = NSPredicate(format: "closed = false")
      projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

      projectsController = NSFetchedResultsController(fetchRequest: projectRequest,
                                                      managedObjectContext: dataController.container.viewContext,
                                                      sectionNameKeyPath: nil,
                                                      cacheName: nil)
      // Construct a fetch request to show the 10  highest-priority incomplete items from open projects.
      let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
      let completedPredicate = NSPredicate(format: "completed = false")
      let openPredicate = NSPredicate(format: "project.closed = false")
      itemRequest.predicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
      itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
      itemRequest.fetchLimit = 10

      itemsController = NSFetchedResultsController(fetchRequest: itemRequest,
                                                   managedObjectContext: dataController.container.viewContext,
                                                   sectionNameKeyPath: nil,
                                                   cacheName: nil)

      super.init()

      projectsController.delegate = self
      itemsController.delegate = self

      do {
        try projectsController.performFetch()
        try itemsController.performFetch()
        projects = projectsController.fetchedObjects ?? []
        items = itemsController.fetchedObjects ?? []
      } catch {
        print("Failed to fetch initial data!")
      }
    }
  }
}
