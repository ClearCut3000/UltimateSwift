//
//  ItemListView.swift
//  UltimateSwift
//
//  Created by Николай Никитин on 24.01.2023.
//

import SwiftUI

struct ItemListView: View {

  // MARK: - View Properties
  let title: LocalizedStringKey
  let items: ArraySlice<Item>

  // MARK: - View Body
  var body: some View {
    if items.isEmpty {
      EmptyView()
    } else {
      Text(title)
        .font(.headline)
        .foregroundColor(.secondary)
        .padding(.top)
      ForEach(items) { item in
        NavigationLink(destination: EditItemView(item: item)) {
          HStack(spacing: 20) {
            Circle()
              .stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
              .frame(width: 44, height: 44)
            VStack(alignment: .leading) {
              Text(item.itemTitle)
                .font(.title2)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)

              if item.itemDetail.isEmpty == false {
                Text(item.itemDetail)
                  .foregroundColor(.secondary)
              }
            }
          }
          .padding()
          .background(Color.secondarySystemGroupedBackground)
          .cornerRadius(10)
          .shadow(color: Color.black.opacity(0.2), radius: 5)
        }
      }
    }
  }
}
