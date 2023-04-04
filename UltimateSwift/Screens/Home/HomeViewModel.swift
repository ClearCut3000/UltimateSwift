//
//  HomeViewModel.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 09.03.2023.
//

import CoreData
import Foundation

extension HomeView {
  class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
    // MARK: - Properties
    private let projectsController: NSFetchedResultsController<Project>
    private let itemsController: NSFetchedResultsController<Item>

    var dataController: DataController

    var upNext: ArraySlice<Item> {
      items.prefix(3)
    }

    var moreToExplore: ArraySlice<Item> {
      items.dropFirst(3)
    }

    @Published var projects = [Project]()
    @Published var items = [Item]()
    @Published var selectedItem: Item?

    // MARK: - Init
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
      let itemRequest = dataController.fetchRequestForTopItems(count: 10)
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

    // MARK: - Methods
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      if let newItems = controller.fetchedObjects as? [Item] {
        items = newItems
      } else if let newProjects = controller.fetchedObjects as? [Project] {
        projects = newProjects
      }
    }

    func addSampleData() {
      dataController.deleteAll()
      try? dataController.createSampleData()
    }

    func selectItem(with identifier: String) {
        selectedItem = dataController.item(with: identifier)
    }
  }
}
