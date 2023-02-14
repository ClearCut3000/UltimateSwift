//
//  UltimateSwiftUITests.swift
//  UltimateSwiftUITests
//
//  Created by Николай Никитин on 14.02.2023.
//

import XCTest

final class UltimateSwiftUITests: XCTestCase {
  var app: XCUIApplication!

  override func setUpWithError() throws {
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments = ["enable-testing"]
    app.launchArguments += ["-AppleLanguages", "(en)"]
    app.launchArguments += ["-AppleLocale", "en_EN"]
    app.launch()
  }

  func testAppHas4Tabs() throws {
    XCTAssertEqual(app.tabBars.buttons.count, 4, "There shoulld be 4 tabs in the app.")
  }

  func testOpenTabsAddsItems() {
    app.buttons["Open"].tap()
    XCTAssertEqual(app.tables.cells.count, 0, "There shoud be no list rows initially.")
    for tapCount in 1...5 {
      app.buttons["Add Project"].tap()
      XCTAssertEqual(app.tables.cells.count, tapCount, "There shoud be \(tapCount) list rows.")
    }
  }

  func testAddingItemInsertsRows() {
    app.buttons["Open"].tap()
    XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")
    app.buttons["Add Project"].tap()
    XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")
    app.buttons["Add New Item"].tap()
    XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding an item.")
  }

  func testEditingProjectUpdatesCorrectly() {
    app.buttons["Open"].tap()
    XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")
    app.buttons["Add Project"].tap()
    XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")
    app.buttons["COMPOSE"].tap()
    app.textFields["New Project"].tap()
    app.keys["space"].tap()
    app.keys["more"].tap()
    app.keys["2"].tap()
    app.buttons["Return"].tap()
    app.buttons["Open Projects"].tap()
    XCTAssertTrue(app.buttons["New Project 2"].exists, "The new project name should be visible in the list.")
  }

  func testEditingItemUpdatesCorrectly() {
    testAddingItemInsertsRows()
    app.buttons["New Item"].tap()
    app.textFields["Item name"].tap()
    app.keys["space"].tap()
    app.keys["more"].tap()
    app.keys["2"].tap()
    app.buttons["Return"].tap()
    app.buttons["Open Projects"].tap()
    XCTAssertTrue(app.buttons["New Item 2"].exists, "The new item name should be visible in the list.")
  }

  func testAllAwardsShowLockedAlert() {
    app.buttons["Awards"].tap()
    for award in app.scrollViews.buttons.allElementsBoundByIndex {
      award.tap()
      XCTAssertTrue(app.alerts["Locked"].exists, "There should be a Locked alert showing for awards.")
      app.buttons["OK"].tap()
    }
  }
}
