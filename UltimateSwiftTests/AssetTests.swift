//
//  AssetTests.swift
//  UltimateSwiftTests
//
//  Created by Николай Никитин on 06.02.2023.
//

import XCTest
@testable import UltimateSwift

class AssetTests: XCTestCase {

  // method to ensure our asset catalog contains all the colors our code expects
  func testColorsExist() {
    for color in Project.colors {
      XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
    }
  }

  // method to check whether the Award.allAwards property is empty or not,
  // because doing so will attempt to load and decode Awards.json from the bundle
  func testJSONLoadsCorrectly() {
      XCTAssertTrue(Award.allAwards.isEmpty == false, "Failed to load awards from JSON.")
  }
}
