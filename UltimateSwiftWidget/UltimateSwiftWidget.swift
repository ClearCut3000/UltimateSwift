//
//  UltimateSwiftWidget.swift
//  UltimateSwiftWidget
//
//  Created by Николай Никитин on 02.04.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
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

struct SimpleEntry: TimelineEntry {
  let date: Date
  let items: [Item]
}

struct UltimateSwiftWidgetEntryView: View {
  var entry: Provider.Entry
  var body: some View {
    VStack {
      Text("Up next...")
        .font(.title)
      if let item = entry.items.first {
        Text(item.itemTitle)
      } else {
        Text("Nothing!")
      }
    }
  }
}

struct UltimateSwiftWidget: Widget {
  let kind: String = "UltimateSwiftWidget"
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      UltimateSwiftWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Up next…")
    .description("Your #1 top-priority item.")
    .supportedFamilies([.systemSmall])
  }
}

struct UltimateSwiftWidget_Previews: PreviewProvider {
  static var previews: some View {
    UltimateSwiftWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
