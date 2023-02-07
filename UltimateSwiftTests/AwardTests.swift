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

  func testNewUserHasNoAwards() {
    for award in awards {
      XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
    }
  }
}
