//
//  HomeView.swift
//  UltimateSwiftMac
//
//  Created by Николай Никитин on 30.04.2023.
//

import SwiftUI

struct HomeView: View {

  // MARK: - View Properties
  static let tag: String? = "Home"
  @StateObject var viewModel: ViewModel

  // MARK: - View Init
  init(dataController: DataController) {
    let viewModel = ViewModel(dataController: dataController)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: - View Body
  var body: some View {
    NavigationView {
      List {
        ItemListView(title: "Up next", items: $viewModel.upNext)
        ItemListView(title: "More to explore", items: $viewModel.moreToExplore)
      }
      .listStyle(.sidebar)
      .navigationTitle("Home")
      .toolbar {
        Button("Add Data", action: viewModel.addSampleData)
      }
    }
  }
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView(dataController: .preview)
  }
}
