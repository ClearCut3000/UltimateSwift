//
//  HomeView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 30.12.2022.
//

import CoreData
import SwiftUI
import CoreSpotlight

struct HomeView: View {

  // MARK: - View Properties
  static let tag: String? = "Home"

  @StateObject var viewModel: ViewModel

  var rows: [GridItem] {
    [GridItem(.fixed(100))]
  }

  // MARK: - View Init
  init(dataController: DataController) {
    let viewModel = ViewModel(dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: - View Body
  var body: some View {
    NavigationView {
      ScrollView {
        if let item = viewModel.selectedItem {
          NavigationLink(destination: EditItemView(item: item),
                         tag: item,
                         selection: $viewModel.selectedItem,
                         label: EmptyView.init)
          .id(item)
        }
        VStack(alignment: .leading) {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows) {
              ForEach(viewModel.projects, content: ProjectSummaryView.init)
            }
            .padding([.horizontal, .top])
            .fixedSize(horizontal: false, vertical: true)
          }
          VStack(alignment: .leading) {
            ItemListView(title: "Up next", items: $viewModel.upNext)
            ItemListView(title: "More to explore", items: $viewModel.moreToExplore)
          }
          .padding(.horizontal)
        }
      }
      .background(Color.systemGroupedBackground.ignoresSafeArea())
      .navigationTitle("Home")
      .toolbar {
        Button("Add Sample Data", action: viewModel.addSampleData)
      }
      .onContinueUserActivity(CSSearchableItemActionType,
                              perform: loadSpotlightItem)
    }
  }

  // MARK: - View Methods
  func loadSpotlightItem(_ userActivity: NSUserActivity) {
    if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
      viewModel.selectItem(with: uniqueIdentifier)
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(dataController: DataController.preview)
  }
}
