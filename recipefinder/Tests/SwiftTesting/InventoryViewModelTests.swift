//
//  InventoryViewModelTests.swift
//  recipefinderTests
//
//  IngredientStore has no injectable initializer, so `store` below is always
//  `.shared`. That's fine for these tests: none of the pending-selection
//  logic in InventoryViewModel actually validates against IngredientStore's
//  contents (togglePendingSelection only checks counts), so we can safely
//  drive it with arbitrary fixture strings.
//

import Testing
import CoreFoundation
import Foundation
@testable import recipefinder

@MainActor
@Suite("InventoryViewModel")
struct InventoryViewModelTests {

    private func makeViewModel(fridgeItems: [String] = []) -> (InventoryViewModel, FridgeStore) {
        let fridgeStore = FridgeStore(defaults: makeIsolatedDefaults())
        if !fridgeItems.isEmpty {
            fridgeStore.addItems(fridgeItems)
        }
        let vm = InventoryViewModel(store: .shared, fridgeStore: fridgeStore)
        return (vm, fridgeStore)
    }

    // MARK: - fridgeSlots

    @Test("fridgeSlots maps filled items to the front slots and leaves the rest empty")
    func fridgeSlots_mapsItemsAndEmptySlots() {
        let (vm, _) = makeViewModel(fridgeItems: ["egg", "milk", "bread"])

        #expect(vm.fridgeSlots.count == 10)
        #expect(vm.fridgeSlots[0].itemName == "egg")
        #expect(vm.fridgeSlots[1].itemName == "milk")
        #expect(vm.fridgeSlots[2].itemName == "bread")
        #expect(vm.fridgeSlots[3].itemName == nil)
        #expect(vm.fridgeSlots[9].itemName == nil)
    }

    @Test("fridgeSlots ids run from 1 through totalSlots")
    func fridgeSlots_idsAreSequential() {
        let (vm, _) = makeViewModel()
        #expect(vm.fridgeSlots.map(\.id) == Array(1...10))
    }

    // MARK: - Slot info alert

    @Test("infoTapped on a filled slot shows the item name and a detail message")
    func infoTapped_filledSlot() {
        let (vm, _) = makeViewModel(fridgeItems: ["egg"])
        let slot = vm.fridgeSlots[0]

        vm.infoTapped(for: slot)

        #expect(vm.showAlert)
        #expect(vm.alertTitle == "egg")
        #expect(vm.alertMessage.contains("egg"))
    }

    @Test("infoTapped on an empty slot shows the empty-slot copy")
    func infoTapped_emptySlot() {
        let (vm, _) = makeViewModel()
        let slot = vm.fridgeSlots[5]

        vm.infoTapped(for: slot)

        #expect(vm.showAlert)
        #expect(vm.alertTitle == "Empty Slot")
        #expect(vm.alertMessage == "This slot is empty. Add an item to fill it.")
    }

    // MARK: - Add items sheet

    @Test("openAddItemsSheet resets pending selection and shows the sheet")
    func openAddItemsSheet_resetsPendingSelection() {
        let (vm, _) = makeViewModel()
        vm.openAddItemsSheet()
        vm.togglePendingSelection("carrot", isOn: true)

        vm.openAddItemsSheet()

        #expect(vm.showAddItemsSheet)
        #expect(!vm.isPendingSelected("carrot"))
    }

    @Test("togglePendingSelection tracks on/off state")
    func togglePendingSelection_tracksState() {
        let (vm, _) = makeViewModel()
        vm.openAddItemsSheet()

        vm.togglePendingSelection("carrot", isOn: true)
        #expect(vm.isPendingSelected("carrot"))

        vm.togglePendingSelection("carrot", isOn: false)
        #expect(!vm.isPendingSelected("carrot"))
    }

    @Test("togglePendingSelection is capped so fridge + pending never exceeds totalSlots")
    func togglePendingSelection_respectsCombinedCap() {
        let (vm, _) = makeViewModel(fridgeItems: (1...9).map { "item\($0)" }) // 9 used, 1 free
        vm.openAddItemsSheet()

        vm.togglePendingSelection("a", isOn: true)  // 9 + 0 < 10 -> allowed
        #expect(vm.isPendingSelected("a"))

        vm.togglePendingSelection("b", isOn: true)  // 9 + 1 < 10 is false -> rejected
        #expect(!vm.isPendingSelected("b"))
    }

    @Test("with an empty fridge, exactly maxAddableItems can be pending at once")
    func togglePendingSelection_respectsMaxAddableItems() {
        let (vm, _) = makeViewModel()
        vm.openAddItemsSheet()

        for i in 1...10 {
            vm.togglePendingSelection("item\(i)", isOn: true)
        }
        vm.togglePendingSelection("overflow", isOn: true)

        #expect(vm.canAddMore == false)
        #expect(!vm.isPendingSelected("overflow"))
    }

    @Test("confirmAddItems commits the pending selection to the fridge and closes the sheet")
    func confirmAddItems_commitsAndCloses() {
        let (vm, fridgeStore) = makeViewModel()
        vm.openAddItemsSheet()
        vm.togglePendingSelection("egg", isOn: true)
        vm.togglePendingSelection("milk", isOn: true)

        vm.confirmAddItems()

        #expect(fridgeStore.fridgeItems.contains("egg"))
        #expect(fridgeStore.fridgeItems.contains("milk"))
        #expect(!vm.isPendingSelected("egg"))
        #expect(!vm.showAddItemsSheet)
    }

    @Test("cancelAddItems discards the pending selection without touching the fridge")
    func cancelAddItems_discardsPending() {
        let (vm, fridgeStore) = makeViewModel()
        vm.openAddItemsSheet()
        vm.togglePendingSelection("egg", isOn: true)

        vm.cancelAddItems()

        #expect(fridgeStore.fridgeItems.isEmpty)
        #expect(!vm.isPendingSelected("egg"))
        #expect(!vm.showAddItemsSheet)
    }

    // MARK: - Removal

    @Test("removeItem delegates to the fridge store")
    func removeItem_delegatesToStore() {
        let (vm, fridgeStore) = makeViewModel(fridgeItems: ["egg", "milk"])

        vm.removeItem("egg")

        #expect(!fridgeStore.fridgeItems.contains("egg"))
        #expect(!vm.fridgeItems.contains("egg"))
    }

    // MARK: - availableIngredients

    @Test("availableIngredients never includes items already in the fridge")
    func availableIngredients_excludesFridgeItems() {
        let (vm, _) = makeViewModel(fridgeItems: ["egg"])

        #expect(!vm.availableIngredients.contains("egg"))
    }

    // MARK: - Scroll progress (existing behavior, unrelated to fridge slots)

    @Test("progress clamps between 0 and 1")
    func progress_isClamped() {
        let (vm, _) = makeViewModel()

        vm.updateScrollOffset(0)
        #expect(vm.progress(screenWidth: 300) == 0)

        vm.updateScrollOffset(-10_000)
        #expect(vm.progress(screenWidth: 300) == 1)
    }

    @Test("progress is 0 when content is not wider than the screen")
    func progress_zeroWhenNoOverflow() {
        let (vm, _) = makeViewModel()
        vm.updateScrollOffset(-50)

        #expect(vm.progress(screenWidth: vm.contentWidth) == 0)
    }
}
