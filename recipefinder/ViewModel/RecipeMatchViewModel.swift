
import Foundation
import SwiftData

func normalizeIngredient(_ text: String) -> String {
    
    var cleaned = text.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if cleaned.hasSuffix("ies") {
        cleaned = String(cleaned.dropLast(3)) + "y"
    } else if cleaned.hasSuffix("es") {
        cleaned = String(cleaned.dropLast(2))
    } else if cleaned.hasSuffix("s") && cleaned.count > 3 {
        cleaned = String(cleaned.dropLast())              }
    return cleaned
}

@MainActor
@Observable
final class RecipeMatchViewModel {
    private(set) var selectedItems: Set<String>
    var isStrictMatch = false

    @ObservationIgnored
    private let allRecipes: [Recipe]

    init(selectedItems: Set<String>, context: ModelContext) {
        self.selectedItems = selectedItems
        let stored = (try? context.fetch(FetchDescriptor<RecipeStored>())) ?? []
        self.allRecipes = stored.map { $0.toRecipe() }
    }

    var selectedIngredients: [String] {
        selectedItems.map { normalizeIngredient($0) }
    }

    var filteredRecipes: [Recipe] {
        allRecipes.filter { recipe in
            let matchCount = recipe.ingredients.filter { selectedIngredients.contains($0) }.count
            return isStrictMatch ? matchCount == recipe.ingredients.count : matchCount >= 4
        }
    }

    func isFullMatch(_ recipe: Recipe) -> Bool {
        recipe.ingredients.allSatisfy { selectedIngredients.contains($0) }
    }
    func matchCountLabel(for recipe: Recipe) -> String {
        "\(selectedItems.count)/\(recipe.ingredients.count)"
    }
}

extension RecipeStored {
    func toRecipe() -> Recipe {
        let ingredientsArray = cleanedIngredients
            .components(separatedBy: ",")
            .map { normalizeIngredient(cleanIngredient($0)) }
            .filter { !$0.isEmpty }
        return Recipe(name: name, ingredients: ingredientsArray, description: instructions)
    }
}
