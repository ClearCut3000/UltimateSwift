//
//  AwardTests.swift
//  UltimateSwiftTests
//
//  Created by Николай Никитин on 07.02.2023.
//

import XCTest
import CoreData
@testable import UltimateSwift

final class AwardTests: BaseTestCase {

  let awards = Award.allAwards

  // do all tests have the same ID as their name?
  func testAwardIDMatchesName() {
    for award in awards {
      XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
    }
  }

  // need to make sure that when a new user comes into the app they have earned no awards
  func testNewUserHasNoAwards() {
    for award in awards {
      XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
    }
  }

  // validate complex awards
  func testItemAwards() throws {
    let values = [1, 10, 20, 50, 100, 250, 500, 1000]
    for (count, value) in values.enumerated() {
      for _ in 0..<value {
        _ = Item(context: managedObjectContext)
      }
      let matches = awards.filter { award in
        award.criterion == "items" && dataController.hasEarned(award: award)
      }
      XCTAssertEqual(matches.count, count + 1, "Adding \(value) items should unlock \(count + 1) awards.")
      dataController.deleteAll()
    }
  }

  // ensures the completed awards also work
  func testCompletedAwards() throws {
    let values = [1, 10, 20, 50, 100, 250, 500, 1000]
    for (count, value) in values.enumerated() {
      for _ in 0..<value {
        let item = Item(context: managedObjectContext)
        item.completed = true
      }
      let matches = awards.filter { award in
        award.criterion == "complete" && dataController.hasEarned(award: award)
      }
      XCTAssertEqual(matches.count, count + 1, "Completing \(value) items should unlock \(count + 1) awards.")
      dataController.deleteAll()
    }
  }
}
