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

    var selectedItems: Set<String> = []
    var searchText = "" {
        didSet { scheduleSearch() }
    }
    var path: [Route] = []

    // MARK: - Dependencies

    @ObservationIgnored
    private let store: IngredientStore

    @ObservationIgnored
    private var searchTask: Task<Void, Never>?

    // MARK: - Init

    init(store: IngredientStore = .shared) {
        self.store = store
    }

    // MARK: - Lifecycle

    func onAppear() {
        filteredIngredients = performSearch(searchText: "", source: store.ingredients)
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

    // MARK: - Navigation

    func goToRecipes() {
        guard !path.contains(.content3) else { return }
        path.append(.content3)
    }

    deinit {
        searchTask?.cancel()
    }
}
