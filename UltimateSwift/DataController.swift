//
//  DataController.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 29.12.2022.
//

import CoreData
import SwiftUI

/// An environment singleton responsible for managing our Core Data stack, including handling saving,
/// counting fetch requests, tracking awards, and dealing with sample data.
class DataController: ObservableObject {

  // MARK: - DataController Properties
  /// The lone CloudKit container used to store all our data.
  let container: NSPersistentCloudKitContainer
  static var preview: DataController = {
    let dataController = DataController(inMemory: true)
    let viewContext = dataController.container.viewContext
    do {
      try dataController.createSampleData()
    } catch {
      fatalError("Fatal error creating preview: \(error.localizedDescription)")
    }
    return dataController
  }()

  /// Load the data model precisely once and share it everywhere we create a DataController
  static let model: NSManagedObjectModel = {
      guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
          fatalError("Failed to locate model file.")
      }
      guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
          fatalError("Failed to load model file.")
      }
      return managedObjectModel
  }()

  // MARK: - DataController Init
  /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
  /// or on permanent storage (for use in regular app runs.)
  /// Defaults to permanent storage.
  /// - Parameter inMemory: Whether to store this data in temporary memory or not.
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
    // For testing and previewing purposes, we create a
    // temporary, in-memory database by writing to /dev/null
    // so our data is destroyed after the app finishes running.
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { _, error in
      if let error {
        fatalError("Fatal error loading store: \(error.localizedDescription)")
      }
      #if DEBUG
      if CommandLine.arguments.contains("enable-testing") {
        self.deleteAll()
        UIView.setAnimationsEnabled(false)
      }
      #endif
    }
  }

  // MARK: - DataController Methods

  /// Creates example projects and items to make manual testing easier.
  /// - Throws: An NSError sent from calling save() on the NSManagedObjectContext.
  func createSampleData() throws {
    let viewContext = container.viewContext

    for projectCounter in 1...5 {
      let project = Project(context: viewContext)
      project.title = "Project \(projectCounter)"
      project.items = []
      project.creationDate = Date()
      project.closed = Bool.random()
      for itemCounter in 1...10 {
        let item = Item(context: viewContext)
        item.title = "Item \(itemCounter)"
        item.creationDate = Date()
        item.completed = Bool.random()
        item.project = project
        item.priority = Int16.random(in: 1...3)
      }
    }
    try viewContext.save()
  }

  /// Saves our Core Data context iff there are changes. This silently ignores
  /// any errors caused by saving, but this should be fine because all our attributes are optional.
  func save() {
    if container.viewContext.hasChanges {
      try? container.viewContext.save()
    }
  }

  func delete(_ object: NSManagedObject) {
    container.viewContext.delete(object)
  }

  func deleteAll() {
    let itemsFetchRequest: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
    let itemsBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: itemsFetchRequest)
    _ = try? container.viewContext.execute(itemsBatchDeleteRequest)

    let projectsFetchRequest: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
    let projectsBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: projectsFetchRequest)
    _ = try? container.viewContext.execute(projectsBatchDeleteRequest)
  }

  func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
    (try? container.viewContext.count(for: fetchRequest)) ?? 0
  }

  func hasEarned(award: Award) -> Bool {
    switch award.criterion {
    case "items":
      // returns true if they added a certain number of items
      let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
      let awardCount = count(for: fetchRequest)
      return awardCount >= award.value
    case "complete":
      // returns true if they completed a certain number of items
      let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
      fetchRequest.predicate = NSPredicate(format: "completed = true")
      let awardCount = count(for: fetchRequest)
      return awardCount >= award.value
    default:
      // an unknown award criterion; this should never be allowed
      //      fatalError("Unknown award criterion: \(award.criterion)")
      return false
    }
  }
}
