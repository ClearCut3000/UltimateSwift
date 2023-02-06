//
//  UltimateSwiftTests.swift
//  UltimateSwiftTests
//
//  Created by Николай Никитин on 06.02.2023.
//

import XCTest
import CoreData
@testable import UltimateSwift

class BaseTestCase: XCTestCase {
  var dataController: DataController!
  var managedObjectContext: NSManagedObjectContext!

  override func setUpWithError() throws {
    dataController = DataController(inMemory: true)
    managedObjectContext = dataController.container.viewContext
  }
}
