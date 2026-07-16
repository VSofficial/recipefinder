//
//  RecipeMatchViewModel.swift
//  recipefinder
//
//  Created by Varun Sharma on 16/07/26.
//


import Foundation
import Observation

@MainActor
@Observable
final class RecipeMatchViewModel {

    // MARK: - Input

    private(set) var selectedItems: Set<String>

    // MARK: - UI State

    var isStrictMatch = false

    // MARK: - Data

    @ObservationIgnored
    private let allRecipes: [Recipe]

    // MARK: - Init

    init(selectedItems: Set<String>) {
        self.selectedItems = selectedItems
        self.allRecipes = (loadRecipes() ?? []).map { $0.toRecipe() }
    }

    // MARK: - Derived state

    var selectedIngredients: [String] {
        selectedItems.map { normalizeIngredient($0) }
    }

    var filteredRecipes: [Recipe] {
        allRecipes.filter { recipe in
            let matchCount = recipe.ingredients.filter {
                selectedIngredients.contains($0)
            }.count

            if isStrictMatch {
                // strict mode: every recipe ingredient must be selected
                return matchCount == recipe.ingredients.count
            } else {
                // relaxed mode: at least 4 matches
                return matchCount >= 4
            }
        }
    }

    // MARK: - Row helpers

    func isFullMatch(_ recipe: Recipe) -> Bool {
        recipe.ingredients.allSatisfy { selectedIngredients.contains($0) }
    }

    func matchCountLabel(for recipe: Recipe) -> String {
        "\(selectedItems.count)/\(recipe.ingredients.count)"
    }
}

// MARK: - Free helper functions (pure logic, no UI dependency)

func normalizeIngredient(_ text: String) -> String {
    var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)

    if cleaned.hasSuffix("ies") {
        cleaned = String(cleaned.dropLast(3)) + "y"
    } else if cleaned.hasSuffix("es") {
        cleaned = String(cleaned.dropLast(2))
    } else if cleaned.hasSuffix("s") && cleaned.count > 3 {
        cleaned = String(cleaned.dropLast())
    }

    return cleaned
}

extension RecipeModelElement {
    func toRecipe() -> Recipe {
        let ingredientsArray = cleanedIngredients
            .components(separatedBy: ",")
            .map { ingredient in
                normalizeIngredient(cleanIngredient(ingredient))
            }
            .filter { !$0.isEmpty }

        return Recipe(
            name: translatedRecipeName,
            ingredients: ingredientsArray,
            description: translatedInstructions
        )
    }
}