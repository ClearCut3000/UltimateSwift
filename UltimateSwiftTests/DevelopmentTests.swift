//
//  DevelopmentTests.swift
//  UltimateSwiftTests
//
//  Created by Николай Никитин on 09.02.2023.
//

import CoreData
import XCTest
@testable import UltimateSwift

final class DevelopmentTests: BaseTestCase {

  // tests to make sure sample code loads correctly
  func testSampleDataCreationWorks() throws {
    try dataController.createSampleData()
    XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects")
    XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 5 sample projects")
  }

  //  tests to make sure deleteAll() method works
  func testDeleteAllClearsEverything() throws {
    try dataController.createSampleData()
    dataController.deleteAll()
    XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "deleteAll() should leave 0 projects.")
    XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "deleteAll() should leave 0 items.")
  }

  // when we create our example project it should be closed by default
  func testExampleProjectIsClosed() {
    let project = Project.example
    XCTAssertTrue(project.closed, "The examplee project should be closed.")
  }

  // when we create our example item it should have a high priority
  func testExampleItemIsHighPriority() {
    let item = Item.example
    XCTAssertEqual(item.priority, 3, "The example item should be high priority.")
  }
}
