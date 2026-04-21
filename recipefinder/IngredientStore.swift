//
//  IngredientStore.swift
//  recipefinder
//
//  Created by Varun Sharma on 20/04/26.
//
import Foundation

final class IngredientStore {
    static let shared = IngredientStore()

    let ingredients: [String]
    let ingredientSet: Set<String>
    let sortedIngredients: [String]

    private init() {
        let raw = loadIngredients()?.ingredients ?? []

        let cleaned = raw.map {
            $0.lowercased()
                .trimmingCharacters(in: .whitespacesAndNewlines)
        }

        self.ingredientSet = Set(cleaned)
        self.ingredients = Array(self.ingredientSet)
        self.sortedIngredients = self.ingredients.sorted { $0.count > $1.count }
    }
}
