//
//  EditProjectView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 03.01.2023.
//

import SwiftUI

struct EditProjectView: View {

  // MARK: - View Properties
  let project: Project
  @EnvironmentObject var dataController: DataController
  @Environment(\.presentationMode) var presentationMode
  @State private var title: String
  @State private var detail: String
  @State private var color: String
  @State private var showingDeleteConform = false
  let colorColumns = [
    GridItem(.adaptive(minimum: 44))
  ]

  // MARK: - View Init
  init(project: Project) {
    self.project = project
    _title = State(wrappedValue: project.projectTitle)
    _detail = State(wrappedValue: project.projectDetail)
    _color = State(wrappedValue: project.projectColor)
  }

  // MARK: - View Body
  var body: some View {
    Form {
      Section(header: Text("Basic Settings")) {
        TextField("Project Name", text: $title.onChange(update))
        TextField("Description of thise project", text: $detail.onChange(update))
      }

      Section(header: Text("Custom Project Color")) {
        LazyVGrid(columns: colorColumns) {
          ForEach(Project.colors, id: \.self, content: colorButton)
        }
        .padding(.vertical)
      }
      // swiftlint:disable:next line_length
      Section(footer: Text("Closing a project moves it from the Open to Closed tab: deleting it removes the project entirely")) {
        Button(project.closed ? "Reopen this project" : "Close this project") {
          project.closed.toggle()
          update()
        }
        Button("Delete this project") {
          showingDeleteConform.toggle()
        }
        .tint(.red)
      }
    }
    .navigationTitle("Edit Project")
    .onDisappear {
      dataController.save()
    }
    .alert(isPresented: $showingDeleteConform) {
      Alert(title: Text("Delete project?"),
            message: Text("Are you sure you want to delete all project? You will also delete all items it contains!"),
            primaryButton: .default(Text("Delete"), action: delete),
            secondaryButton: .cancel())
    }
  }

  // MARK: - View Methods
  func update() {
    project.title = title
    project.detail = detail
    project.color = color
  }

  func delete() {
    dataController.delete(project)
    presentationMode.wrappedValue.dismiss()
  }

  func colorButton(for item: String) -> some View {
    ZStack {
      Color(item)
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(6)
      if item == color {
        Image(systemName: "checkmark.circle")
          .foregroundColor(.white)
          .font(.largeTitle)
      }
    }
    .onTapGesture {
      color = item
      update()
    }
    .accessibilityElement(children: .ignore)
    .accessibilityAddTraits(item == color ? [.isButton, .isSelected] : .isButton)
    .accessibilityLabel(LocalizedStringKey(item))
  }
}

struct EditProjectView_Previews: PreviewProvider {
  static var previews: some View {
    EditProjectView(project: Project.example)
  }
}
