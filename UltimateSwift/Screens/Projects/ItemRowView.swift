//
//  ItemRowView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 01.01.2023.
//

import SwiftUI

struct ItemRowView: View {

  // MARK: - View Properties
  @StateObject var viewModel: ViewModel
  @ObservedObject var item: Item

  // MARK: - Init
  init(project: Project, item: Item) {
    let viewModel = ViewModel(project: project, item: item)
    _viewModel = StateObject(wrappedValue: viewModel)

    self.item = item
  }

  // MARK: - View Body
    var body: some View {
      NavigationLink {
        EditItemView(item: item)
      } label: {
        Label {
          Text(item.itemTitle)
        } icon: {
          Image(systemName: viewModel.icon)
            .foregroundColor(viewModel.color.map { Color($0) } ?? .clear)
        }
      }
      .accessibilityLabel(viewModel.label)
    }
}

struct IteemRowView_Previews: PreviewProvider {
    static var previews: some View {
      ItemRowView(project: Project.example, item: Item.example)
    }
}
