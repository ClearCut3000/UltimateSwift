//
//  IteemRowView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 01.01.2023.
//

import SwiftUI

struct IteemRowView: View {

  //MARK: - View Properties
  @ObservedObject var item: Item

  //MARK: - View Body
    var body: some View {
      NavigationLink {
        EditItemView(item: item)
      } label: {
        Text(item.itemTitle)
      }
    }
}

struct IteemRowView_Previews: PreviewProvider {
    static var previews: some View {
      IteemRowView(item: Item.example)
    }
}