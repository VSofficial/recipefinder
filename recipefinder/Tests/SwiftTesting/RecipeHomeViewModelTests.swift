//
//  RecipeHomeViewModelTests.swift
//  recipefinderTests
//
//  Search-result content depends on the real bundled IngredientStore data
//  (not injectable), so the search test below asserts on shape/behavior
//  (debounce firing, no-match returning empty) rather than specific
//  ingredient names.
//

import Testing
@testable import recipefinder

@MainActor
@Suite("RecipeHomeViewModel")
struct RecipeHomeViewModelTests {

    private func makeViewModel(fridgeItems: [String] = []) -> (RecipeHomeViewModel, FridgeStore) {
        let fridgeStore = FridgeStore(defaults: makeIsolatedDefaults())
        if !fridgeItems.isEmpty {
            fridgeStore.addItems(fridgeItems)
        }
        let vm = RecipeHomeViewModel(store: .shared, fridgeStore: fridgeStore)
        return (vm, fridgeStore)
    }

    @Test("onAppear populates filteredIngredients from the full ingredient list")
    func onAppear_populatesFilteredIngredients() {
        let (vm, _) = makeViewModel()

        vm.onAppear()

        #expect(vm.filteredIngredients.count == IngredientStore.shared.ingredients.count)
    }

    @Test("onAppear auto-selects everything already physically in the fridge")
    func onAppear_autoSelectsFridgeItems() {
        let (vm, _) = makeViewModel(fridgeItems: ["egg", "milk"])

        vm.onAppear()

        #expect(vm.isSelected("egg"))
        #expect(vm.isSelected("milk"))
    }

    @Test("toggleSelection and removeFromSelection delegate to the fridge store")
    func selection_delegatesToFridgeStore() {
        let (vm, fridgeStore) = makeViewModel()

        vm.toggleSelection("onion", isOn: true)
        #expect(fridgeStore.isSelected("onion"))
        #expect(vm.isSelected("onion"))

        vm.removeFromSelection("onion")
        #expect(!fridgeStore.isSelected("onion"))
        #expect(!vm.isSelected("onion"))
    }

    @Test("isInFridge reflects physical fridge contents, not selection")
    func isInFridge_reflectsFridgeStore() {
        let (vm, _) = makeViewModel(fridgeItems: ["egg"])

        #expect(vm.isInFridge("egg"))
        #expect(!vm.isInFridge("milk"))
    }

    @Test("a search with no possible matches settles on an empty result after the debounce")
    func search_withNoMatches_settlesEmpty() async throws {
        let (vm, _) = makeViewModel()
        vm.onAppear()

        vm.searchText = "zzznonexistentingredientzzz"
        try await Task.sleep(for: .milliseconds(400))

        #expect(vm.filteredIngredients.isEmpty)
    }

    @Test("clearing the search text restores the full ingredient list after the debounce")
    func search_clearingRestoresFullList() async throws {
        let (vm, _) = makeViewModel()
        vm.onAppear()

        vm.searchText = "zzznonexistentingredientzzz"
        try await Task.sleep(for: .milliseconds(400))
        #expect(vm.filteredIngredients.isEmpty)

        vm.searchText = ""
        try await Task.sleep(for: .milliseconds(400))
        #expect(vm.filteredIngredients.count == IngredientStore.shared.ingredients.count)
    }

    @Test("goToRecipes appends the recipe route exactly once")
    func goToRecipes_appendsRouteOnce() {
        let (vm, _) = makeViewModel()

        vm.goToRecipes()
        vm.goToRecipes()
        vm.goToRecipes()

        #expect(vm.path == [.content3])
    }
}
