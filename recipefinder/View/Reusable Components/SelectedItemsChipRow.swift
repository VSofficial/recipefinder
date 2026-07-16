//
//  SelectedItemsChipRow.swift
//  recipefinder
//
//  Created by Varun Sharma on 16/07/26.
//


import SwiftUI

/// A horizontally scrolling row of removable pill-shaped chips.
/// Reusable anywhere you need to display a set of selectable/removable tags.
struct SelectedItemsChipRow: View {
    let items: [String]
    let onRemove: (String) -> Void

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    ChipView(label: item) {
                        onRemove(item)
                    }
                }
            }
            .padding(10)
        }
        .fixedSize(horizontal: false, vertical: true)
        .scrollIndicators(.hidden)
    }
}

/// A single removable pill/chip.
private struct ChipView: View {
    let label: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(label)
                .font(.system(size: 20))

            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(.black.opacity(0.8))
                .onTapGesture {
                    onRemove()
                }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(Color.yellow.opacity(0.2))
        .clipShape(Capsule())
    }
}

#Preview {
    SelectedItemsChipRow(
        items: ["Tomato", "Potato", "Salt", "Oil"],
        onRemove: { print("removed \($0)") }
    )
}