//
//  PerformanceTests.swift
//  UltimateSwiftTests
//
//  Created by Николай Никитин on 11.02.2023.
//

import XCTest
@testable import UltimateSwift

final class PerformanceTests: BaseTestCase {

  // performance test that monitors how fast app can calculate which awards the user has earned
  func testAwardCalculationPerformance() throws {
    // Create a significant amount of test data
    for _ in 1...100 {
      try dataController.createSampleData()
    }
    // Simulate lots of awards to check
    let awards = Array(repeating: Award.allAwards, count: 25).joined()
    XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")
    measure {
      _ = awards.filter(dataController.hasEarned)
    }
  }
}
