//
//  AddFridgeItemsSheet.swift
//  recipefinder
//
//  Created by Varun Sharma on 16/07/26.
//


import SwiftUI

struct AddFridgeItemsSheet: View {
    let viewModel: InventoryViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("\(viewModel.pendingSelection.count)/\(viewModel.maxAddableItems) selected")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)

                CheckableIngredientList(
                    items: viewModel.availableIngredients,
                    isSelected: viewModel.isPendingSelected,
                    onToggle: viewModel.togglePendingSelection
                )
            }
            .navigationTitle("Add to Fridge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.cancelAddItems()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.confirmAddItems()
                    }
                    .disabled(viewModel.pendingSelection.isEmpty)
                }
            }
        }
    }
}