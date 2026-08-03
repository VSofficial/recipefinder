//
//  FridgeStore.swift
//  recipefinder
//
//  Created by Varun Sharma on 03/08/26.
//


//
//  FridgeStore.swift
//  recipefinder
//

import Foundation
import Observation

@MainActor
@Observable
final class FridgeStore {
    static let shared = FridgeStore()

    /// Items physically in the fridge (max 10, mapped to shelf slots)
    private(set) var fridgeItems: [String] = []

    /// Items the user has marked as "on hand" for recipe matching —
    /// shared between RecipeHome and Inventory
    var selectedItems: Set<String> = []

    let totalSlots = 10

    private init() {}

    // MARK: - Fridge mutations
    func addItems(_ items: some Sequence<String>) {
        let remainingSlots = totalSlots - fridgeItems.count
        fridgeItems.append(contentsOf: items.prefix(remainingSlots))
    }

    func removeItem(_ item: String) {
        fridgeItems.removeAll { $0 == item }
        selectedItems.remove(item)   // keep selection consistent with inventory
    }

    // MARK: - Selection
    func isSelected(_ item: String) -> Bool {
        selectedItems.contains(item)
    }

    func toggleSelection(_ item: String, isOn: Bool) {
        if isOn {
            selectedItems.insert(item)
        } else {
            selectedItems.remove(item)
        }
    }

    func removeFromSelection(_ item: String) {
        selectedItems.remove(item)
    }
}