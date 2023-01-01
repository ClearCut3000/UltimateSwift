//
//  EditItemView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 31.12.2022.
//

import SwiftUI

struct EditItemView: View {

  //MARK: - View Properties
  let item: Item
  @EnvironmentObject var dataController: DataController
  @State private var title: String
  @State private var detail: String
  @State private var priority: Int
  @State private var completed: Bool

  //MARK: - View Init
  init(item: Item) {
    self.item = item
    _title = State(wrappedValue: item.itemTitle)
    _detail = State(wrappedValue: item.itemDetail)
    _priority = State(wrappedValue: Int(item.priority))
    _completed = State(wrappedValue: item.completed)
  }

  //MARK: - View Body
    var body: some View {
      Form {
        Section(header: Text("Basic settings")) {
          TextField("Item Name", text: $title)
          TextField("Description", text: $detail)
        }
        Section(header: Text("Priority")) {
          Picker("Priority", selection: $priority) {
            Text("Low").tag(1)
            Text("Medium").tag(2)
            Text("High").tag(3)
          }
          .pickerStyle(.segmented)
        }
        Section {
          Toggle("Mark Completed", isOn: $completed)
        }
      }
      .navigationTitle("Edit Item")
    }
}

struct EditItemView_Previews: PreviewProvider {
    static var previews: some View {
      EditItemView(item: Item.example)
    }
}
