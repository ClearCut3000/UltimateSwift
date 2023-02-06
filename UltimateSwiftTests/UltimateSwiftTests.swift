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
  var manajeedObjectContext: NSManagedObjectContext!

  override func setUpWithError() throws {
    dataController = DataController(inMemory: true)
    manajeedObjectContext = dataController.container.viewContext
  }
}
