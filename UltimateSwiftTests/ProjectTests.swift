//
//  ProjectTests.swift
//  UltimateSwiftTests
//
//  Created by Николай Никитин on 06.02.2023.
//

import CoreData
import XCTest
@testable import UltimateSwift

class ProjectTests: BaseTestCase {

  // methods tests can we create new project/items objects, and have them stashed away
  func testCreatingProjectSAndItems() {
    let targetCount = 10
    for _ in 0..<targetCount {
      let project = Project(context: managedObjectContext)
      for _ in 0..<targetCount {
        let item = Item(context: managedObjectContext)
        item.project = project
      }
    }
    XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
    XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
  }

  // cascade delete testing
  func testDeletingProjectCascadeDeletesItems() throws {
    // 1 - can we create our standard set of sample data?
    try dataController.createSampleData()
    // 2 - fetch all projects
    let request = NSFetchRequest<Project>(entityName: "Project")
    let projects = try managedObjectContext.fetch(request)
    // 3 - delete the first one of them
    dataController.delete(projects[0])
    // 4 - assert that we have 4 projects and 40 items remaining
    XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 4)
    XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 40)
  }
}
