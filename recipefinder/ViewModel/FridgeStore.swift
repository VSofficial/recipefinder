//
//  FridgeStore.swift
//  recipefinder
//
//  Created by Varun Sharma on 03/08/26.
//


import Foundation
import Observation

@MainActor
@Observable
final class FridgeStore {
    static let shared = FridgeStore()

    // MARK: - Persistence
    @ObservationIgnored
    private let defaults: UserDefaults
    private let fridgeItemsKey = "FridgeStore.fridgeItems"
    private let selectedItemsKey = "FridgeStore.selectedItems"

    /// Items physically in the fridge (max 10, mapped to shelf slots)
    private(set) var fridgeItems: [String] = [] {
        didSet { persistFridgeItems() }
    }

    /// Items the user has marked as "on hand" for recipe matching
    var selectedItems: Set<String> = [] {
        didSet { persistSelectedItems() }
    }

    let totalSlots = 10

     init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        loadFridgeItems()
        loadSelectedItems()
    }

    // MARK: - Fridge mutations
    func addItems(_ items: some Sequence<String>) {
        let remainingSlots = totalSlots - fridgeItems.count
        fridgeItems.append(contentsOf: items.prefix(remainingSlots))
    }

    func removeItem(_ item: String) {
        fridgeItems.removeAll { $0 == item }
        selectedItems.remove(item)
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

    // MARK: - Persistence helpers
    private func persistFridgeItems() {
        defaults.set(fridgeItems, forKey: fridgeItemsKey)
    }

    private func loadFridgeItems() {
        fridgeItems = defaults.stringArray(forKey: fridgeItemsKey) ?? []
    }

    private func persistSelectedItems() {
        defaults.set(Array(selectedItems), forKey: selectedItemsKey)
    }

    private func loadSelectedItems() {
        let array = defaults.stringArray(forKey: selectedItemsKey) ?? []
        selectedItems = Set(array)
    }
}

