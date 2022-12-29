//
//  DataController.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 29.12.2022.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {

  //MARK: - DataController Properties
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

  //MARK: - DataController Init
  init(inMemory: Bool = false) {
    container = NSPersistentCloudKitContainer(name: "Main")
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { storeDescription, error in
      if let error {
        fatalError("Fatal error loading store: \(error.localizedDescription)")
      }
    }
  }

  //MARK: - DataController Methods
  func createSampleData() throws {
    let viewContext = container.viewContext

    for i in 1...5 {
      let project = Project(context: viewContext)
      project.title = "Project \(i)"
      project.items = []
      project.creationDate = Date()
      project.closed = Bool.random()
      for j in 1...10 {
        let item = Item(context: viewContext)
        item.title = "Item \(j)"
        item.creationDate = Date()
        item.completed = Bool.random()
        item.project = project
        item.priority = Int16.random(in: 1...3)
      }
    }
    try viewContext.save()
  }

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
}
