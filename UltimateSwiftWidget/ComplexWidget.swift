//
//  ComplexWidget.swift
//  UltimateSwiftWidget
//
//  Created by Николай Никитин on 02.04.2023.
//

import WidgetKit
import SwiftUI
import Intents

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

struct ComplexUltimateSwiftWidget_Previews: PreviewProvider {
  static var previews: some View {
    UltimateSwiftWidgetMultipleEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
      .previewContext(WidgetPreviewContext(family: .systemLarge))
  }
}
