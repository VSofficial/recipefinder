//
//  IngredientStoreTests.swift
//  recipefinderTests
//
//  NOTE: IngredientStore loads its data from a bundled resource via a
//  private, non-injectable `loadIngredients()` call inside `init()`, and
//  there's no initializer that accepts a custom ingredient list. That means
//  these tests can only verify invariants of whatever `.shared` happens to
//  contain in the test target, not specific expected ingredients. If real
//  determinism is wanted here, consider giving IngredientStore an
//  `init(loader: () -> IngredientsFile?)` so tests can inject fixture data.
//

import Testing
import Foundation

@testable import recipefinder

@Suite("IngredientStore")
struct IngredientStoreTests {

    @Test("ingredients and ingredientSet contain the same elements with no duplicates")
    func ingredients_haveNoDuplicates() {
        let store = IngredientStore.shared

        #expect(store.ingredients.count == store.ingredientSet.count)
        #expect(Set(store.ingredients) == store.ingredientSet)
    }

    @Test("every ingredient is lowercased and trimmed of whitespace")
    func ingredients_areNormalized() {
        let store = IngredientStore.shared

        for ingredient in store.ingredients {
            #expect(ingredient == ingredient.lowercased())
            #expect(ingredient == ingredient.trimmingCharacters(in: .whitespacesAndNewlines))
        }
    }

    @Test("sortedIngredients contains exactly the same elements as ingredients")
    func sortedIngredients_isAPermutation() {
        let store = IngredientStore.shared

        #expect(Set(store.sortedIngredients) == store.ingredientSet)
        #expect(store.sortedIngredients.count == store.ingredients.count)
    }

    @Test("sortedIngredients is ordered by descending character count")
    func sortedIngredients_isDescendingByLength() {
        let store = IngredientStore.shared

        let lengths = store.sortedIngredients.map(\.count)
        #expect(lengths == lengths.sorted(by: >))
    }

    @Test(".shared always returns the same instance")
    func shared_isASingleton() {
        #expect(IngredientStore.shared === IngredientStore.shared)
    }
}
