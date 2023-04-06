//
//  UltimateSwiftWidget.swift
//  UltimateSwiftWidget
//
//  Created by Николай Никитин on 02.04.2023.
//

import WidgetKit
import SwiftUI
import Intents

// MARK: - TimelineProvider
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

// MARK: - TimelineEntry
struct SimpleEntry: TimelineEntry {
  let date: Date
  let items: [Item]
}

// MARK: - View's
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

struct UltimateSwiftWidgetMultipleEntryView: View {
  /// Properties
  @Environment(\.widgetFamily) var widgetFamily
  @Environment(\.sizeCategory) var sizeCategory
  let entry: Provider.Entry
  var items: ArraySlice<Item> {
    let itemCount: Int
    switch widgetFamily {
    case .systemSmall:
      itemCount = 1
    case .systemLarge:
      if sizeCategory < .extraExtraLarge {
        itemCount = 5
      } else {
        itemCount = 4
      }
    default:
      if sizeCategory < .extraLarge {
        itemCount = 3
      } else {
        itemCount = 2
      }
    }
    return entry.items.prefix(itemCount)
  }

  /// Body
  var body: some View {
    VStack(spacing: 5) {
      ForEach(entry.items) { item in
        HStack {
          Color(item.project?.color ?? "Light Blue")
            .frame(width: 5)
            .clipShape(Capsule())
          VStack(alignment: .leading) {
            Text(item.itemTitle)
              .font(.headline)
              .layoutPriority(1)
            if let projectTitle = item.project?.projectTitle {
              Text(projectTitle)
                .foregroundColor(.secondary)
            }
          }
          Spacer()
        }
      }
    }
    .padding(20)
  }
}

// MARK: - Widget's
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

struct ComplexUltimateSwiftWidget: Widget {
  let kind: String = "ComplexUltimateSwiftWidget"
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      UltimateSwiftWidgetMultipleEntryView(entry: entry)
    }
    .configurationDisplayName("Up next…")
    .description("Your most important items.")
  }
}

struct UltimateSwiftWidget_Previews: PreviewProvider {
  static var previews: some View {
    UltimateSwiftWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
