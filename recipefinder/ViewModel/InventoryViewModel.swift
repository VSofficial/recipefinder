//////
//////  InventoryViewModel.swift
//////  recipefinder
//////
//////  Created by Varun Sharma on 16/07/26.
//////
////
////import SwiftUI
////import Observation
////
////@MainActor
////@Observable
////final class InventoryViewModel {
////
////    // MARK: - Data
////
////    private(set) var items: [Int] = Array(1...10)
////    private(set) var items2: [Int] = Array(1...6)
////
////    // MARK: - UI State
////
////    var scrollOffset: CGFloat = 0
////    var showAlert = false
////
////    // MARK: - Constants (view-agnostic layout data)
////
////    let contentWidth: CGFloat = 600
////    let alertTitle = "Item Info"
////    let alertMessage = "This shows extra details about the item."
////
////    let columns = [
////        GridItem(.flexible()),
////        GridItem(.flexible())
////    ]
////
////    let columns2 = [
////        GridItem(.flexible()),
////        GridItem(.flexible()),
////        GridItem(.flexible())
////    ]
////
////    // MARK: - Intents
////
////    /// Called from the ScrollOffsetKey preference change handler.
////    func updateScrollOffset(_ minX: CGFloat) {
////        scrollOffset = -minX
////    }
////
////    /// Called when the "info" plus button is tapped.
////    func infoButtonTapped() {
////        showAlert = true
////    }
////    
////    
////
////    /// Computes horizontal scroll progress (0...1) given the visible screen width.
////    func progress(screenWidth: CGFloat) -> CGFloat {
////        let maxScroll = contentWidth - screenWidth
////        guard maxScroll > 0 else { return 0 }
////        return min(max(scrollOffset / maxScroll, 0), 1)
////    }
////}
//
//import SwiftUI
//import Observation
//
//@MainActor
//@Observable
//final class InventoryViewModel {
//
//    // MARK: - Fridge Items
//
//    private(set) var fridgeItems: [String] = []
//
//    // MARK: - Add Items Sheet
//
//    var showAddItemsSheet = false
//    private(set) var pendingSelection: Set<String> = []
//    let maxAddableItems = 10
//
//    @ObservationIgnored
//    private let store: IngredientStore
//
//    var availableIngredients: [String] {
//        store.ingredients.filter { !fridgeItems.contains($0) }
//    }
//
//    var canAddMore: Bool {
//        pendingSelection.count < maxAddableItems
//    }
//
//    // MARK: - Existing grid data (unchanged)
//
//    private(set) var items: [Int] = Array(1...10)
//    private(set) var items2: [Int] = Array(1...6)
//
//    var scrollOffset: CGFloat = 0
//    var showAlert = false
//
//    let contentWidth: CGFloat = 600
//    let alertTitle = "Item Info"
//    let alertMessage = "This shows extra details about the item."
//
//    let columns = [GridItem(.flexible()), GridItem(.flexible())]
//    let columns2 = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
//
//    // MARK: - Init
//
//    init(store: IngredientStore = .shared) {
//        self.store = store
//    }
//
//    // MARK: - Add Items Sheet intents
//
//    func openAddItemsSheet() {
//        pendingSelection = []
//        showAddItemsSheet = true
//    }
//
//    func isPendingSelected(_ item: String) -> Bool {
//        pendingSelection.contains(item)
//    }
//
//    func togglePendingSelection(_ item: String, isOn: Bool) {
//        if isOn {
//            guard canAddMore else { return }
//            pendingSelection.insert(item)
//        } else {
//            pendingSelection.remove(item)
//        }
//    }
//
//    func confirmAddItems() {
//        fridgeItems.append(contentsOf: pendingSelection)
//        pendingSelection = []
//        showAddItemsSheet = false
//    }
//
//    func cancelAddItems() {
//        pendingSelection = []
//        showAddItemsSheet = false
//    }
//
//    func removeItem(_ item: String) {
//        fridgeItems.removeAll { $0 == item }
//    }
//
//    // MARK: - Existing intents (unchanged)
//
//    func updateScrollOffset(_ minX: CGFloat) {
//        scrollOffset = -minX
//    }
//
//    func progress(screenWidth: CGFloat) -> CGFloat {
//        let maxScroll = contentWidth - screenWidth
//        guard maxScroll > 0 else { return 0 }
//        return min(max(scrollOffset / maxScroll, 0), 1)
//    }
//}

import SwiftUI
import Observation

struct FridgeSlot: Identifiable {
    let id: Int          // 1...10, matches shelf position
    let itemName: String?
}

@MainActor
@Observable
final class InventoryViewModel {

    // MARK: - Fridge Items

    private(set) var fridgeItems: [String] = []
    let totalSlots = 10

    /// Maps fridgeItems onto the 10 numbered shelf positions from the fridge image.
    /// Empty slots (beyond what's been added) show as nil.
    var fridgeSlots: [FridgeSlot] {
        (1...totalSlots).map { index in
            let itemName = index <= fridgeItems.count ? fridgeItems[index - 1] : nil
            return FridgeSlot(id: index, itemName: itemName)
        }
    }

    // MARK: - Add Items Sheet

    var showAddItemsSheet = false
    private(set) var pendingSelection: Set<String> = []
    let maxAddableItems = 10

    @ObservationIgnored
    private let store: IngredientStore

    var availableIngredients: [String] {
        store.ingredients.filter { !fridgeItems.contains($0) }
    }

    var canAddMore: Bool {
        pendingSelection.count < maxAddableItems
    }

    // MARK: - Slot info alert

    var showAlert = false
    private var selectedSlot: FridgeSlot?

    var alertTitle: String {
        selectedSlot?.itemName ?? "Empty Slot"
    }

    var alertMessage: String {
        if let name = selectedSlot?.itemName {
            return "This shows extra details about \(name)."
        } else {
            return "This slot is empty. Add an item to fill it."
        }
    }

    // MARK: - Existing grid data (door shelves — unrelated to numbered slots)

    private(set) var items2: [Int] = Array(1...6)

    var scrollOffset: CGFloat = 0
    let contentWidth: CGFloat = 600

    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let columns2 = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    // MARK: - Init

    init(store: IngredientStore = .shared) {
        self.store = store
    }

    // MARK: - Slot intents

    func infoTapped(for slot: FridgeSlot) {
        selectedSlot = slot
        showAlert = true
    }

    // MARK: - Add Items Sheet intents

    func openAddItemsSheet() {
        pendingSelection = []
        showAddItemsSheet = true
    }

    func isPendingSelected(_ item: String) -> Bool {
        pendingSelection.contains(item)
    }

    func togglePendingSelection(_ item: String, isOn: Bool) {
        if isOn {
            guard canAddMore, fridgeItems.count + pendingSelection.count < totalSlots else { return }
            pendingSelection.insert(item)
        } else {
            pendingSelection.remove(item)
        }
    }

    func confirmAddItems() {
        let remainingSlots = totalSlots - fridgeItems.count
        fridgeItems.append(contentsOf: pendingSelection.prefix(remainingSlots))
        pendingSelection = []
        showAddItemsSheet = false
    }

    func cancelAddItems() {
        pendingSelection = []
        showAddItemsSheet = false
    }

    func removeItem(_ item: String) {
        fridgeItems.removeAll { $0 == item }
    }

    // MARK: - Existing intents (unchanged)

    func updateScrollOffset(_ minX: CGFloat) {
        scrollOffset = -minX
    }

    func progress(screenWidth: CGFloat) -> CGFloat {
        let maxScroll = contentWidth - screenWidth
        guard maxScroll > 0 else { return 0 }
        return min(max(scrollOffset / maxScroll, 0), 1)
    }
}
