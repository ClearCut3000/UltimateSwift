//
//  HomeView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 30.12.2022.
//

import CoreData
import SwiftUI

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
        VStack(alignment: .leading) {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows) {
              ForEach(viewModel.projects, content: ProjectSummaryView.init)
            }
            .padding([.horizontal, .top])
            .fixedSize(horizontal: false, vertical: true)
          }
          VStack(alignment: .leading) {
            ItemListView(title: "Up next", items: viewModel.upNext)
            ItemListView(title: "More to explore", items: viewModel.moreToExplore)
          }
          .padding(.horizontal)
        }
      }
      .background(Color.systemGroupedBackground.ignoresSafeArea())
      .navigationTitle("Home")
      .toolbar {
        Button("Add Sample Data", action: viewModel.addSampleData)
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(dataController: DataController.preview)
  }
}
