import SwiftUI
import Observation

struct FridgeSlot: Identifiable {
    let id: Int          // 1...10, matches shelf position
    let itemName: String?
}

@MainActor
@Observable
final class InventoryViewModel {
    // MARK: - Fridge Items (proxied to shared store)
    var fridgeItems: [String] { fridgeStore.fridgeItems }
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
    @ObservationIgnored
    private let fridgeStore: FridgeStore

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
    init(store: IngredientStore = .shared, fridgeStore: FridgeStore = .shared) {
        self.store = store
        self.fridgeStore = fridgeStore
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
        fridgeStore.addItems(pendingSelection)
        pendingSelection = []
        showAddItemsSheet = false
    }

    func cancelAddItems() {
        pendingSelection = []
        showAddItemsSheet = false
    }

    func removeItem(_ item: String) {
        fridgeStore.removeItem(item)
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

