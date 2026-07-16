//
//  CheckableIngredientList.swift
//  recipefinder
//
//  Created by Varun Sharma on 16/07/26.
//


import SwiftUI

/// A vertically scrolling list of items, each with an icon, label, and checkbox.
/// Reusable anywhere you need a selectable list — recipe ingredients, fridge contents, etc.
struct CheckableIngredientList: View {
    let items: [String]
    let iconName: String
    let isSelected: (String) -> Bool
    let onToggle: (String, Bool) -> Void

    init(
        items: [String],
        iconName: String = "veggie",
        isSelected: @escaping (String) -> Bool,
        onToggle: @escaping (String, Bool) -> Void
    ) {
        self.items = items
        self.iconName = iconName
        self.isSelected = isSelected
        self.onToggle = onToggle
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(items, id: \.self) { item in
                    CheckableIngredientRow(
                        label: item,
                        iconName: iconName,
                        isChecked: Binding(
                            get: { isSelected(item) },
                            set: { onToggle(item, $0) }
                        )
                    )
                }
            }
            .padding()
        }
    }
}

private struct CheckableIngredientRow: View {
    let label: String
    let iconName: String
    @Binding var isChecked: Bool

    var body: some View {
        HStack {
            Image(iconName)
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange.opacity(0.8))

            Text(label)

            Spacer()

            CheckboxView(isChecked: $isChecked)
        }
        .padding()
        .background(.yellow.opacity(0.10))
        .cornerRadius(10)
    }
}

#Preview {
    CheckableIngredientList(
        items: ["Tomato", "Potato", "Salt", "Oil"],
        isSelected: { _ in false },
        onToggle: { item, value in print(item, value) }
    )
}