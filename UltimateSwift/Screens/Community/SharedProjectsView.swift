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

  func fetchSharedProjects() {
    guard loadState == .inactive else { return }
    loadState = .loading
    let pred = NSPredicate(value: true)
    let sort = NSSortDescriptor(key: "creationDate", ascending: false)
    let query = CKQuery(recordType: "Project", predicate: pred)
    query.sortDescriptors = [sort]
    let operation = CKQueryOperation(query: query)
    operation.desiredKeys = ["title", "detail", "owner", "closed"]
    operation.resultsLimit = 50
    /// will be called once for each record downloaded by CloudKit as a result of our query
    operation.recordFetchedBlock = { record in
      let id = record.recordID.recordName
      let title = record["title"] as? String ?? "No title"
      let detail = record["detail"] as? String ?? ""
      let owner = record["owner"] as? String ?? "No owner"
      let closed = record["closed"] as? Bool ?? false
      let sharedProject = SharedProject(id: id, title: title, detail: detail, owner: owner, closed: closed)
      projects.append(sharedProject)
      loadState = .success
    }
    /// will be called when all records have been retrieved
    operation.queryCompletionBlock = { _, _ in
      if projects.isEmpty {
        loadState = .noResults
      }
    }
    CKContainer.default().publicCloudDatabase.add(operation)
  }
}


