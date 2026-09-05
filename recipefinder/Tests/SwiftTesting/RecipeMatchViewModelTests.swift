//
//  RecipeMatchViewModelTests.swift
//  recipefinderTests
//
//  `allRecipes` is populated internally from `loadRecipes()` with no
//  injection point, so `filteredRecipes` can't be exercised against known
//  fixture data here — it depends on whatever recipes ship in the test
//  target's bundle. `isFullMatch` and `matchCountLabel`, however, only take
//  a `Recipe` value as a parameter, so they're fully testable by
//  constructing `Recipe` values directly. Consider adding an
//  `init(selectedItems:recipeLoader:)` to RecipeMatchViewModel if
//  `filteredRecipes` needs deterministic coverage later.

import Testing
@testable import recipefinder

@MainActor
@Suite("RecipeMatchViewModel")
struct RecipeMatchViewModelTests {

    // MARK: - selectedIngredients

    @Test("selectedIngredients normalizes each selected item")
    func selectedIngredients_normalizesItems() {
        let vm = RecipeMatchViewModel(selectedItems: ["tomatoes", "onions", "milk"])

        let normalized = Set(vm.selectedIngredients)
        #expect(normalized == ["tomato", "onion", "milk"])
    }

    // MARK: - isFullMatch

    @Test("isFullMatch is true when every recipe ingredient is selected")
    func isFullMatch_trueWhenAllIngredientsSelected() {
        let vm = RecipeMatchViewModel(selectedItems: ["tomato", "onion", "salt"])
        let recipe = Recipe(name: "Test Soup", ingredients: ["tomato", "onion"], description: "")

        #expect(vm.isFullMatch(recipe))
    }

    @Test("isFullMatch is false when a recipe ingredient is missing")
    func isFullMatch_falseWhenIngredientMissing() {
        let vm = RecipeMatchViewModel(selectedItems: ["tomato"])
        let recipe = Recipe(name: "Test Soup", ingredients: ["tomato", "onion"], description: "")

        #expect(!vm.isFullMatch(recipe))
    }

    @Test("isFullMatch matches after normalization, e.g. plural selections")
    func isFullMatch_matchesAfterNormalization() {
        let vm = RecipeMatchViewModel(selectedItems: ["tomatoes", "onions"])
        let recipe = Recipe(name: "Test Soup", ingredients: ["tomato", "onion"], description: "")

        #expect(vm.isFullMatch(recipe))
    }

    @Test("an empty-ingredient recipe is trivially a full match")
    func isFullMatch_emptyRecipe_isTrue() {
        let vm = RecipeMatchViewModel(selectedItems: [])
        let recipe = Recipe(name: "Empty", ingredients: [], description: "")

        #expect(vm.isFullMatch(recipe))
    }

    // MARK: - matchCountLabel

    @Test("matchCountLabel formats as selectedCount/recipeIngredientCount")
    func matchCountLabel_formatsCounts() {
        let vm = RecipeMatchViewModel(selectedItems: ["tomato", "onion", "salt"])
        let recipe = Recipe(name: "Test Soup", ingredients: ["tomato", "onion"], description: "")

        #expect(vm.matchCountLabel(for: recipe) == "3/2")
    }

    // MARK: - isStrictMatch toggle

    @Test("isStrictMatch defaults to false")
    func isStrictMatch_defaultsFalse() {
        let vm = RecipeMatchViewModel(selectedItems: [])
        #expect(!vm.isStrictMatch)
    }
}
