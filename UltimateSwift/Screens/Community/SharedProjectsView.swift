//
//  SharedProjectsView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 14.04.2023.
//

import CloudKit
import SwiftUI

struct SharedProjectsView: View {
  static let tag: String? = "Community"

  @State private var projects = [SharedProject]()
  @State private var loadState = LoadState.inactive

  var body: some View {
    NavigationView {
      Group {
        switch loadState {
        case .inactive, .loading:
          ProgressView()
        case .noResults:
          Text("No results")
        case .success:
          List(projects) { project in
            NavigationLink(destination: Color.blue) {
              VStack(alignment: .leading) {
                Text(project.title)
                  .font(.headline)
                Text(project.owner)
              }
            }
          }
          .listStyle(InsetGroupedListStyle())
        }
      }
      .navigationTitle("Shared Projects")
    }
    .onAppear(perform: fetchSharedProjects)
  }
}

func fetchSharedProjects() {
}
