//
//  RecipeHomeViewModel.swift
//  recipefinder
//
//  Created by Varun Sharma on 16/07/26.
//

import Foundation
import Observation


@MainActor
@Observable
final class RecipeHomeViewModel {
    // MARK: - Data
    private(set) var filteredIngredients: [String] = []

    // MARK: - UI State
    var searchText = "" {
        didSet { scheduleSearch() }
    }
    var path: [Route] = []

    @ObservationIgnored
    private let store: IngredientStore
    @ObservationIgnored
    private let fridgeStore: FridgeStore
    @ObservationIgnored
    private var searchTask: Task<Void, Never>?

    init(store: IngredientStore = .shared, fridgeStore: FridgeStore = .shared) {
        self.store = store
        self.fridgeStore = fridgeStore
    }

    // MARK: - Selection (proxied to shared store)
    var selectedItems: Set<String> {
        fridgeStore.selectedItems
    }

    /// Items physically in the fridge — surfaced here so the view can badge them
    var fridgeItems: [String] {
        fridgeStore.fridgeItems
    }

    func isSelected(_ item: String) -> Bool {
        fridgeStore.isSelected(item)
    }

    func isInFridge(_ item: String) -> Bool {
        fridgeStore.fridgeItems.contains(item)
    }

    func toggleSelection(_ item: String, isOn: Bool) {
        fridgeStore.toggleSelection(item, isOn: isOn)
    }

    func removeFromSelection(_ item: String) {
        fridgeStore.removeFromSelection(item)
    }

    // MARK: - Lifecycle
    func onAppear() {
        filteredIngredients = performSearch(searchText: "", source: store.ingredients)
        // Auto-select anything already in the fridge
        for item in fridgeStore.fridgeItems where !fridgeStore.selectedItems.contains(item) {
            fridgeStore.toggleSelection(item, isOn: true)
        }
    }

    // MARK: - Search
    private func scheduleSearch() {
        searchTask?.cancel()
        let query = searchText
        let source = store.ingredients
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(200))
            guard !Task.isCancelled else { return }
            let result = performSearch(searchText: query, source: source)
            guard !Task.isCancelled else { return }
            self?.filteredIngredients = result
        }
    }

    // MARK: - Navigation
    func goToRecipes() {
        guard !path.contains(.content3) else { return }
        path.append(.content3)
    }

    deinit {
        searchTask?.cancel()
    }
}

