//
//  DataController.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 29.12.2022.
//

import CoreData
import CoreSpotlight
import SwiftUI
import WidgetKit

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

  /// The UserDefaults suite where we're saving user data.
  let defaults: UserDefaults

  /// Loads and saves whether our premium unlock has been purchased.
  var fullVersionUnlocked: Bool {
    get {
      defaults.bool(forKey: "fullVersionUnlocked")
    }
    set {
      defaults.set(newValue, forKey: "fullVersionUnlocked")
    }
  }

  // MARK: - DataController Init
  /// Initializes a data controller, either in memory (for temporary use such as testing and previewing),
  /// or on permanent storage (for use in regular app runs.)
  /// Defaults to permanent storage.
  /// - Parameter inMemory: Whether to store this data in temporary memory or not.
  /// - Parameter defaults: The UserDefaults suite where user data should be stored
  init(inMemory: Bool = false, defaults: UserDefaults = .standard) {
    self.defaults = defaults
    container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
    // For testing and previewing purposes, we create a
    // temporary, in-memory database by writing to /dev/null
    // so our data is destroyed after the app finishes running.
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    } else {
      let groupID = "group.com.example.UltimateSwift"
      if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
        container.persistentStoreDescriptions.first?.url = url.appendingPathComponent("Main.sqlite")
      }
    }
    container.loadPersistentStores { _, error in
      if let error {
        fatalError("Fatal error loading store: \(error.localizedDescription)")
      }
      self.container.viewContext.automaticallyMergesChangesFromParent = true
#if DEBUG
      if CommandLine.arguments.contains("enable-testing") {
        self.deleteAll()
#if os(iOS)
        UIView.setAnimationsEnabled(false)
#endif
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

  /// accepts a particular item, write that item’s information to Spotlight,
  /// then call save() on the data controller so it updates Core Data as well
  /// - Parameter item: Item object
  func update(_ item: Item) {
    let itemID = item.objectID.uriRepresentation().absoluteString
    let projectID = item.project?.objectID.uriRepresentation().absoluteString
    let attributeSet = CSSearchableItemAttributeSet(contentType: .text)
    attributeSet.title = item.title
    attributeSet.contentDescription = item.detail
    let searchableItem = CSSearchableItem(
      uniqueIdentifier: itemID,
      domainIdentifier: projectID,
      attributeSet: attributeSet
    )
    CSSearchableIndex.default().indexSearchableItems([searchableItem])
    save()
  }

  /// Saves our Core Data context iff there are changes. This silently ignores
  /// any errors caused by saving, but this should be fine because all our attributes are optional.
  func save() {
    if container.viewContext.hasChanges {
      try? container.viewContext.save()
      WidgetCenter.shared.reloadAllTimelines()
    }
  }

  /// Method for converting unique identifier from Spotlight to Item for  figuring out which object was selected
  /// - Parameter uniqueIdentifier: String Identifier from Spotlight
  /// - Returns: Selected Item
  func item(with uniqueIdentifier: String) -> Item? {
    guard let url = URL(string: uniqueIdentifier) else {
      return nil
    }
    guard let id = container.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) else {
      return nil
    }
    return try? container.viewContext.existingObject(with: id) as? Item
  }

  func delete(_ object: NSManagedObject) {
    let id = object.objectID.uriRepresentation().absoluteString
    if object is Item {
      CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [id])
    } else {
      CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [id])
    }
    container.viewContext.delete(object)
  }

  func deleteAll() {
    let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
    delete(fetchRequest1)
    let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
    delete(fetchRequest2)
  }

  /// asking the batch delete request to send back all the object IDs that got deleted
  /// array of object IDs goes into a dictionary with the key NSDeletedObjectsKey,
  /// with a default empty array if it can’t be read
  /// dictionary goes into the mergeChanges() method, which updates view context
  /// with the changes just made to the persistent store
  private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
    let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    batchDeleteRequest1.resultType = .resultTypeObjectIDs
    if let delete = try? container.viewContext.execute(batchDeleteRequest1) as? NSBatchDeleteResult {
      let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
      NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
    }
  }

  func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
    (try? container.viewContext.count(for: fetchRequest)) ?? 0
  }

  /// Method return a Boolean to say whether the new project was added successfully or not when using quick action
  @discardableResult func addProject() -> Bool {
    let canCreate = fullVersionUnlocked || count(for: Project.fetchRequest()) < 3

    if canCreate {
      let project = Project(context: container.viewContext)
      project.closed = false
      project.creationDate = Date()
      save()
      return true
    } else {
      return false
    }
  }

  /// Method that fetch one Item object that is not completed, belongs to an open project, and has the highest priority.
  func fetchRequestForTopItems(count: Int) -> NSFetchRequest<Item> {
    let itemRequest: NSFetchRequest<Item> = Item.fetchRequest()
    let completedPredicate = NSPredicate(format: "completed = false")
    let openPredicate = NSPredicate(format: "project.closed = false")
    let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
    itemRequest.predicate = compoundPredicate
    itemRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority,
                                                    ascending: false)]
    itemRequest.fetchLimit = count
    return itemRequest
  }

  func results<T: NSManagedObject>(for fetchRequest: NSFetchRequest<T>) -> [T] {
    return (try? container.viewContext.fetch(fetchRequest)) ?? []
  }
}
