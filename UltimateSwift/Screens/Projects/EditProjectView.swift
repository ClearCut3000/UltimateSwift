//
//  EditProjectView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 03.01.2023.
//

import CoreHaptics
import SwiftUI
import CloudKit

struct EditProjectView: View {

  // MARK: - View Properties
  @ObservedObject var project: Project
  @EnvironmentObject var dataController: DataController
  @Environment(\.presentationMode) var presentationMode
  @AppStorage("username") var username: String?
  @State private var showingSignIn = false
  @State private var title: String
  @State private var detail: String
  @State private var color: String
  @State private var showingDeleteConform = false
  @State private var engine = try? CHHapticEngine()
  @State private var remindMe: Bool
  @State private var reminderTime: Date
  @State private var showingNotificationsError = false
  let colorColumns = [
    GridItem(.adaptive(minimum: 44))
  ]
  enum CloudStatus {
    case checking, exists, absent
  }
  @State private var cloudStatus = CloudStatus.checking
  @State private var cloudError: CloudError?

  // MARK: - View Init
  init(project: Project) {
    self.project = project
    _title = State(wrappedValue: project.projectTitle)
    _detail = State(wrappedValue: project.projectDetail)
    _color = State(wrappedValue: project.projectColor)

    if let projectReminderTime = project.reminderTime {
      _reminderTime = State(wrappedValue: projectReminderTime)
      _remindMe = State(wrappedValue: true)
    } else {
      _reminderTime = State(wrappedValue: Date())
      _remindMe = State(wrappedValue: false)
    }
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
      Section(header: Text("Project reminders")) {
        Toggle("Show reminders", isOn: $remindMe.animation().onChange {
          update()
        })
        .alert("Oops!", isPresented: $showingNotificationsError) {
#if os(iOS)
          Button("Check Settings", action: showAppSettings)
#endif
          Button("OK") { }
        } message: {
          Text("There was a problem. Please check you have notifications enabled.")
        }
        if remindMe {
          DatePicker("Reminder Time",
                     selection: $reminderTime.onChange(update),
                     displayedComponents: .hourAndMinute)
        }
      }
      // swiftlint:disable:next line_length
      Section(footer: Text("Closing a project moves it from the Open to Closed tab: deleting it removes the project entirely")) {
        Button(project.closed ? "Reopen this project" : "Close this project", action: toggleClosed)
        Button("Delete this project") {
          showingDeleteConform.toggle()
        }
        .accentColor(.red)
        .alert(isPresented: $showingDeleteConform) {
          Alert(title: Text("Delete project?"),
                message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), // swiftlint:disable:this line_length
                primaryButton: .default(Text("Delete"), action: delete),
                secondaryButton: .cancel())
        }
        .tint(.red)
      }
    }
    .navigationTitle("Edit Project")
    .toolbar {
      switch cloudStatus {
      case .checking:
        ProgressView()
      case .exists:
        Button {
          removeFromCloud(deleteLocal: false)
        } label: {
          Label("Remove from iCloud", systemImage: "icloud.slash")
        }
      case .absent:
        Button(action: uploadToCloud) {
          Label("Upload to iCloud", systemImage: "icloud.and.arrow.up")
        }
      }
    }
    .onAppear(perform: updateCloudStatus)
    .onDisappear {
      dataController.save()
    }
    .alert(item: $cloudError) { error in
      Alert(
        title: Text("There was an error"),
        message: Text(error.localizedMessage)
      )
    }
    .sheet(isPresented: $showingSignIn, content: SignInView.init)
  }

  // MARK: - View Methods
  func update() {
    project.title = title
    project.detail = detail
    project.color = color
    if remindMe {
      project.reminderTime = reminderTime
      dataController.addReminders(for: project) { success in
        if success == false {
          project.reminderTime = nil
          remindMe = false
          showingNotificationsError = true
        }
      }
    } else {
      project.reminderTime = nil
      dataController.removeReminders(for: project)
    }
  }

  func delete() {
    if cloudStatus == .exists {
      removeFromCloud(deleteLocal: true)
    } else {
      dataController.delete(project)
      presentationMode.wrappedValue.dismiss()
    }
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

  func toggleClosed() {
    project.closed.toggle()
    if project.closed {
      do {
        try? engine?.start()
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl,
                                               controlPoints: [start, end],
                                               relativeTime: 0)
        let event1 = CHHapticEvent(eventType: .hapticTransient,
                                   parameters: [intensity, sharpness],
                                   relativeTime: 0)
        let event2 = CHHapticEvent(eventType: .hapticContinuous,
                                   parameters: [sharpness, intensity],
                                   relativeTime: 0.125,
                                   duration: 1)
        let pattern = try CHHapticPattern(events: [event1, event2],
                                          parameterCurves: [parameter])
        let player = try engine?.makePlayer(with: pattern)
        try player?.start(atTime: 0)
      } catch {

      }
    }
  }

#if os(iOS)
  func showAppSettings() {
    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
    if UIApplication.shared.canOpenURL(settingsUrl) {
      UIApplication.shared.open(settingsUrl)
    }
  }
#endif

  func uploadToCloud() {
    if let username = username {
      let records = project.prepareCloudRecords(owner: username)
      let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
      operation.savePolicy = .allKeys
      operation.modifyRecordsCompletionBlock = { _, _, error in
        if let error = error {
          cloudError = error.getCloudKitError()
        }
        updateCloudStatus()
      }
      cloudStatus = .checking
      CKContainer.default().publicCloudDatabase.add(operation)
    } else {
      showingSignIn = true
    }
  }

  func updateCloudStatus() {
    project.checkCloudStatus { exists in
      if exists {
        cloudStatus = .exists
      } else {
        cloudStatus = .absent
      }
    }
  }

  func removeFromCloud(deleteLocal: Bool) {
    let name = project.objectID.uriRepresentation().absoluteString
    let id = CKRecord.ID(recordName: name)
    let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [id])
    operation.modifyRecordsCompletionBlock = { _, _, error in
      if let error = error {
        cloudError = error.getCloudKitError()
      } else {
        if deleteLocal {
          dataController.delete(project)
          presentationMode.wrappedValue.dismiss()
        }
      }
      updateCloudStatus()
    }
    cloudStatus = .checking
    CKContainer.default().publicCloudDatabase.add(operation)
  }
}

struct EditProjectView_Previews: PreviewProvider {
  static var previews: some View {
    EditProjectView(project: Project.example)
  }
}
