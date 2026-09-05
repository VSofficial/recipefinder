//
//  FridgeStoreTests.swift
//  recipefinderTests
//

import Testing
import Foundation
@testable import recipefinder

@MainActor
@Suite("FridgeStore")
struct FridgeStoreTests {

    // MARK: - addItems

    @Test("Adding items within capacity stores them in order")
    func addItems_withinCapacity() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())
        store.addItems(["egg", "milk", "bread"])

        #expect(store.fridgeItems == ["egg", "milk", "bread"])
    }

    @Test("Adding items beyond the 10 slot cap truncates the overflow")
    func addItems_beyondCapacity_truncates() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())
        let twelveItems = (1...12).map { "item\($0)" }

        store.addItems(twelveItems)

        #expect(store.fridgeItems.count == store.totalSlots)
        #expect(store.fridgeItems == Array(twelveItems.prefix(10)))
    }

    @Test("Adding items when already full is a no-op")
    func addItems_whenFull_isNoOp() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())
        store.addItems((1...10).map { "item\($0)" })

        store.addItems(["overflow"])

        #expect(store.fridgeItems.count == 10)
        #expect(!store.fridgeItems.contains("overflow"))
    }

    @Test("Adding items tops up only the remaining slots")
    func addItems_topsUpRemainingSlots() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())
        store.addItems((1...8).map { "item\($0)" }) // 8 filled, 2 remaining

        store.addItems(["a", "b", "c"]) // only 2 should land

        #expect(store.fridgeItems.count == 10)
        #expect(store.fridgeItems.suffix(2) == ["a", "b"])
    }

    // MARK: - removeItem

    @Test("Removing an item drops it from the fridge and from selection")
    func removeItem_clearsFridgeAndSelection() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())
        store.addItems(["egg", "milk"])
        store.toggleSelection("egg", isOn: true)

        store.removeItem("egg")

        #expect(!store.fridgeItems.contains("egg"))
        #expect(store.fridgeItems == ["milk"])
        #expect(!store.isSelected("egg"))
    }

    @Test("Removing an item not present is a no-op")
    func removeItem_notPresent_isNoOp() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())
        store.addItems(["egg"])

        store.removeItem("ghost")

        #expect(store.fridgeItems == ["egg"])
    }

    // MARK: - Selection

    @Test("toggleSelection adds and removes from selection independent of fridge contents")
    func toggleSelection_addsAndRemoves() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())

        store.toggleSelection("onion", isOn: true)
        #expect(store.isSelected("onion"))

        store.toggleSelection("onion", isOn: false)
        #expect(!store.isSelected("onion"))
    }

    @Test("removeFromSelection only affects selection, not the fridge contents")
    func removeFromSelection_doesNotTouchFridge() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())
        store.addItems(["egg"])
        store.toggleSelection("egg", isOn: true)

        store.removeFromSelection("egg")

        #expect(!store.isSelected("egg"))
        #expect(store.fridgeItems == ["egg"]) // still physically in fridge
    }

    // MARK: - Persistence

    @Test("Fridge items and selection persist across store instances sharing defaults")
    func persistence_roundTrips() {
        let defaults = makeIsolatedDefaults()
        let first = FridgeStore(defaults: defaults)
        first.addItems(["egg", "milk"])
        first.toggleSelection("egg", isOn: true)

        let second = FridgeStore(defaults: defaults)

        #expect(second.fridgeItems == ["egg", "milk"])
        #expect(second.isSelected("egg"))
        #expect(!second.isSelected("milk"))
    }

    @Test("A fresh defaults suite starts empty")
    func freshStore_startsEmpty() {
        let store = FridgeStore(defaults: makeIsolatedDefaults())

        #expect(store.fridgeItems.isEmpty)
        #expect(store.selectedItems.isEmpty)
    }
}
