//
//  HomeView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 30.12.2022.
//

import SwiftUI

struct HomeView: View {

  //MARK: - View Properties
  @EnvironmentObject var dataController: DataController

  //MARK: - View Body
    var body: some View {
      NavigationStack {
        VStack {
          Button("Add Data") {
            dataController.deleteAll()
            try? dataController.createSampleData()
          }
        }
        .navigationTitle("Home")
      }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
