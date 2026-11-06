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
import SwiftData
@testable import recipefinder

@MainActor
@Suite("RecipeMatchViewModel")
struct RecipeMatchViewModelTests {

    private func makeContext() throws -> ModelContext {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(
                for: RecipeStored.self,
                configurations: config
            )
            return ModelContext(container)
        }
    
    // MARK: - selectedIngredients

    @Test("selectedIngredients normalizes each selected item")
    func selectedIngredients_normalizesItems() throws {
        let context = try makeContext()
        let vm = RecipeMatchViewModel(selectedItems: ["tomatoes", "onions", "milk"], context: context)

        let normalized = Set(vm.selectedIngredients)
        #expect(normalized == ["tomato", "onion", "milk"])
    }

    // MARK: - isFullMatch

    @Test("isFullMatch is true when every recipe ingredient is selected")
    func isFullMatch_trueWhenAllIngredientsSelected() throws {
        let context = try makeContext()
        let vm = RecipeMatchViewModel(selectedItems: ["tomato", "onion", "salt"], context: context)
        let recipe = Recipe(name: "Test Soup", ingredients: ["tomato", "onion"], description: "", URL: "")

        #expect(vm.isFullMatch(recipe))
    }

    @Test("isFullMatch is false when a recipe ingredient is missing")
    func isFullMatch_falseWhenIngredientMissing() throws {
        let context = try makeContext()
        let vm = RecipeMatchViewModel(selectedItems: ["tomato"], context: context)
        let recipe = Recipe(name: "Test Soup", ingredients: ["tomato", "onion"], description: "", URL: "")

        #expect(!vm.isFullMatch(recipe))
    }

    @Test("isFullMatch matches after normalization, e.g. plural selections")
    func isFullMatch_matchesAfterNormalization() throws {
        let context = try makeContext()
        let vm = RecipeMatchViewModel(selectedItems: ["tomatoes", "onions"], context: context)
        let recipe = Recipe(name: "Test Soup", ingredients: ["tomato", "onion"], description: "", URL: "")

        #expect(vm.isFullMatch(recipe))
    }

    @Test("an empty-ingredient recipe is trivially a full match")
    func isFullMatch_emptyRecipe_isTrue() throws {
        let context = try makeContext()
        let vm = RecipeMatchViewModel(selectedItems: [], context: context)
        let recipe = Recipe(name: "Empty", ingredients: [], description: "", URL: "")

        #expect(vm.isFullMatch(recipe))
    }

    // MARK: - matchCountLabel

    @Test("matchCountLabel formats as selectedCount/recipeIngredientCount")
    func matchCountLabel_formatsCounts() throws {
        let context = try makeContext()
        let vm = RecipeMatchViewModel(selectedItems: ["tomato", "onion", "salt"], context: context)
        let recipe = Recipe(name: "Test Soup", ingredients: ["tomato", "onion"], description: "", URL: "")

        #expect(vm.matchCountLabel(for: recipe) == "3/2")
    }

    // MARK: - isStrictMatch toggle

    @Test("isStrictMatch defaults to false")
    func isStrictMatch_defaultsFalse() throws {
        let context = try makeContext()
        let vm = RecipeMatchViewModel(selectedItems: [], context: context)
        #expect(!vm.isStrictMatch)
    }
}
