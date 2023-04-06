//
//  SimpleWidget.swift
//  UltimateSwiftWidgetExtension
//
//  Created by Николай Никитин on 07.04.2023.
//

import SwiftUI
import WidgetKit

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
