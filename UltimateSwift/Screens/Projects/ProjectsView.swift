//
//  ProjectsView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 30.12.2022.
//

import SwiftUI

struct ProjectsView: View {

  // MARK: - View Properties
  @State private var showingSortOrder = false
  @StateObject var viewModel: ViewModel

  static let openTag: String? = "Open"
  static let closedTag: String? = "Closed"

  var  projectsList: some View {
    List {
      ForEach(viewModel.projects) { project in
        Section(header: ProjectHeaderView(project: project)) {
          ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
            ItemRowView(project: project, item: item)
          }
          .onDelete { offsets in
            viewModel.delete(offsets, from: project)
          }
          if viewModel.showClosedProjects == false {
            Button {
              withAnimation {
                viewModel.addItem(to: project)
              }
            } label: {
              Label("Add New Item", systemImage: "plus")
            }
          }
        }
      }
    }
    .listStyle(.insetGrouped)
  }
  var addProjectToollbarItem: some ToolbarContent {
    ToolbarItem(placement: .navigationBarTrailing) {
      if viewModel.showClosedProjects == false {
        Button {
          withAnimation {
            viewModel.addProject()
          }
        } label: {
          // In iOS 14.3 VoiceOver has a glitch that reads the label
          // "Add Project" as "Add" no matter what accessibility label
          // we give this button when using a label. As a result, when
          // VoiceOver is running we use a text view for the button instead,
          // forcing a correct reading without losing the original layout.
          if UIAccessibility.isVoiceOverRunning {
            Text("Add Project")
          } else {
            Label("Add Project", systemImage: "plus")
          }
        }
      }
    }
  }
  var sortOrderToolbarItem: some ToolbarContent {
    ToolbarItem(placement: .navigationBarLeading) {
      Button {
        showingSortOrder.toggle()
      } label: {
        Label("Sort", systemImage: "arrow.up.arrow.down")
      }
    }
  }

  // MARK: - Init
  init(dataController: DataController, showClosedProjects: Bool) {
    let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
    _viewModel = StateObject(wrappedValue: viewModel)
  }

  // MARK: - View Body
  var body: some View {
    NavigationView {
      Group {
        if viewModel.projects.isEmpty {
          Text("There is nothing here yet!")
            .foregroundColor(.secondary)
        } else {
          projectsList
        }
      }
      .navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
      .toolbar {
        addProjectToollbarItem
        sortOrderToolbarItem
      }
      .actionSheet(isPresented: $showingSortOrder) {
        ActionSheet(title: Text("Sort Items"), message: nil, buttons: [
          .default(Text("Optimazed")) { viewModel.sortOrder = .optimazed },
          .default(Text("Creation Date")) { viewModel.sortOrder = .creationDate },
          .default(Text("Title")) { viewModel.sortOrder = .title }
        ])
      }
      SelectSomethingView()
    }
    .sheet(isPresented: $viewModel.showingUnlockView) {
      UnlockView()
    }
  }
}

struct ProjectsView_Previews: PreviewProvider {
  static var dataController = DataController.preview

  static var previews: some View {
    ProjectsView(dataController: DataController.preview, showClosedProjects: false)
  }
}
