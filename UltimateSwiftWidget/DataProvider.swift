//
//  DataProvider.swift
//  UltimateSwiftWidgetExtension
//
//  Created by Николай Никитин on 07.04.2023.
//

import WidgetKit
import SwiftUI

// MARK: - TimelineProvider
struct Provider: TimelineProvider {
  typealias Entry = SimpleEntry

  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), items: [Item.example])
  }

  func getSnapshot(in context: Context,
                   completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), items: loadItems())
    completion(entry)
  }

  func getTimeline(in context: Context,
                   completion: @escaping (Timeline<Entry>) -> Void) {
    let entry = SimpleEntry(date: Date(), items: loadItems())
    let timeline = Timeline(entries: [entry], policy: .never)
    completion(timeline)
  }

  func loadItems() -> [Item] {
    let dataController = DataController()
    let itemRequest = dataController.fetchRequestForTopItems(count: 1)
    return dataController.results(for: itemRequest)
  }
}

// MARK: - TimelineEntry
struct SimpleEntry: TimelineEntry {
  let date: Date
  let items: [Item]
}
