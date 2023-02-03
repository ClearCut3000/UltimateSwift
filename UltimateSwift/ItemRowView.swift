//
//  ItemRowView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 01.01.2023.
//

import SwiftUI

struct ItemRowView: View {

  // MARK: - View Properties
  @ObservedObject var project: Project
  @ObservedObject var item: Item
  var icon: some View {
    if item.completed {
      return Image(systemName: "checkmark.circle")
        .foregroundColor(Color(project.projectColor))
    } else if item.priority == 3 {
      return Image(systemName: "exclamationmark.triangle")
        .foregroundColor(Color(project.projectColor))
    } else {
      return Image(systemName: "checkmark.circle")
        .foregroundColor(.clear)
    }
  }

  var label: Text {
    if item.completed {
      return Text("\(item.itemTitle), completed.")
    } else if item.priority == 3 {
      return Text("\(item.itemTitle), high priority.")
    } else {
      return Text("\(item.itemTitle)")
    }
  }

  // MARK: - View Body
    var body: some View {
      NavigationLink {
        EditItemView(item: item)
      } label: {
        Label {
          Text(item.itemTitle)
        } icon: {
          icon
        }
      }
      .accessibilityLabel(label)
    }
}

struct IteemRowView_Previews: PreviewProvider {
    static var previews: some View {
      ItemRowView(project: Project.example, item: Item.example)
    }
}
