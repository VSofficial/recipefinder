//
//  Recipe.swift
//  recipefinder
//
//  Created by Varun Sharma on 05/09/26.
//
import SwiftData
import Foundation

@Model
final class RecipeStored {
    @Attribute(.unique) var url: String
    var name: String
    var ingredientsRaw: String
    var cleanedIngredients: String
    var instructions: String
    var cuisine: String
    var totalTimeInMins: Int
    var imageURL: String
    var ingredientCount: Int

    init(
        url: String,
        name: String,
        ingredientsRaw: String,
        cleanedIngredients: String,
        instructions: String,
        cuisine: String,
        totalTimeInMins: Int,
        imageURL: String,
        ingredientCount: Int
    ) {
        self.url = url
        self.name = name
        self.ingredientsRaw = ingredientsRaw
        self.cleanedIngredients = cleanedIngredients
        self.instructions = instructions
        self.cuisine = cuisine
        self.totalTimeInMins = totalTimeInMins
        self.imageURL = imageURL
        self.ingredientCount = ingredientCount
    }
}



@MainActor
func seedRecipesIfNeeded(context: ModelContext) {
    let descriptor = FetchDescriptor<RecipeStored>()
    let existingCount = (try? context.fetchCount(descriptor)) ?? 0
    guard existingCount == 0 else { return }

    guard let seedElements = loadRecipes() else { return }

    var seenURLs = Set<String>()
    for element in seedElements {
        guard !seenURLs.contains(element.url) else { continue }   // skip duplicates
        seenURLs.insert(element.url)

        context.insert(RecipeStored(
            url: element.url,
            name: element.translatedRecipeName,
            ingredientsRaw: element.translatedIngredients,
            cleanedIngredients: element.cleanedIngredients,
            instructions: element.translatedInstructions,
            cuisine: element.cuisine,
            totalTimeInMins: element.totalTimeInMins,
            imageURL: element.imageURL,
            ingredientCount: element.ingredientCount
        ))
    }

    do {
        try context.save()
        print("Seeded \(seenURLs.count) recipes")
    } catch {
        print("Seed save failed:", error)   // now you'll actually SEE if it's still failing
    }
}

