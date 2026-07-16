//
//  RecipeModel.swift
//  recipefinder
//
//  Created by Varun Sharma on 19/03/26.
//

import Foundation

struct IngredientsList: Codable {
    let ingredients: [String]
}

func loadIngredients() -> IngredientsList? {
    guard let url = Bundle.main.url(forResource: "ingredients", withExtension: "json") else {
        print("File not found")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let recipes = try JSONDecoder().decode(IngredientsList.self, from: data)
        return recipes
    } catch {
        print("Decoding error:", error)
        return nil
    }
}


// MARK: - RecipeModelElement
struct RecipeModelElement: Codable {
    let translatedRecipeName, translatedIngredients: String
    let totalTimeInMins: Int
    let cuisine, translatedInstructions: String
    let url: String
    let cleanedIngredients: String
    let imageURL: String
    let ingredientCount: Int

    enum CodingKeys: String, CodingKey {
        case translatedRecipeName = "TranslatedRecipeName"
        case translatedIngredients = "TranslatedIngredients"
        case totalTimeInMins = "TotalTimeInMins"
        case cuisine = "Cuisine"
        case translatedInstructions = "TranslatedInstructions"
        case url = "URL"
        case cleanedIngredients = "Cleaned-Ingredients"
        case imageURL = "image-url"
        case ingredientCount = "Ingredient-count"
    }
}

typealias RecipeModel = [RecipeModelElement]


func loadRecipes() -> RecipeModel? {
    guard let url = Bundle.main.url(forResource: "Cleaned_Indian_Food_Dataset", withExtension: "json") else {
        print("File not found")
        return nil
    }

    do {
        let data = try Data(contentsOf: url)
        let recipes = try JSONDecoder().decode(RecipeModel.self, from: data)
        return recipes
    } catch {
        print("Decoding error:", error)
        return nil
    }
}

//func extractAllIngredients(from recipes: RecipeModel) -> [String] {
//    var all: Set<String> = []
//
//    for recipe in recipes {
//        let items = recipe.cleanedIngredients
//            .lowercased()
//            .components(separatedBy: ",")
//            .map { cleanIngredient($0) }
//
//
//        all.formUnion(items.filter { !$0.isEmpty })
//    }
//
//    return Array(all)
//}

func extractAllIngredients(from recipes: RecipeModel) -> [String] {
    var all = Set<String>()

    for recipe in recipes {
        let items = recipe.cleanedIngredients
            .components(separatedBy: ",")
            .map { raw -> String in
                var text = raw.lowercased()
                
                // Normalize spaces
                text = text.trimmingCharacters(in: .whitespacesAndNewlines)
                text = text.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
                
                // Remove numbers (like 1/2, 2 etc.)
                text = text.replacingOccurrences(
                    of: "[0-9]+(/[0-9]+)?",
                    with: "",
                    options: .regularExpression
                )
                
                // Remove special characters
                text = text.replacingOccurrences(
                    of: "[^a-zA-Z ]",
                    with: "",
                    options: .regularExpression
                )
                
                // Final trim again
                text = text.trimmingCharacters(in: .whitespacesAndNewlines)
                
           
                return text
            }
            .filter { !$0.isEmpty }

        all.formUnion(items)
    }

    return Array(all).sorted()
}


func cleanIngredient(_ text: String) -> String {
    var cleaned = text.lowercased()
    
    // Remove numbers (including fractions like 1/2)
    cleaned = cleaned.replacingOccurrences(
        of: "[0-9]+(/[0-9]+)?",
        with: "",
        options: .regularExpression
    )
    
    // Remove special characters
    cleaned = cleaned.replacingOccurrences(
        of: "[^a-zA-Z ]",
        with: "",
        options: .regularExpression
    )
    
    // Remove common unwanted words
    let stopWords: Set<String> = [
        "fresh", "chopped", "sliced", "diced", "minced",
        "large", "small", "medium", "optional", "to", "taste"
    ]
    
    let words = cleaned
        .components(separatedBy: " ")
        .filter { !$0.isEmpty && !stopWords.contains($0) }
    
    // ✅ Keep only first 1–2 meaningful words
    let limitedWords = Array(words.prefix(2))
    
    return limitedWords.joined(separator: " ")
}




func categorizeIngredients(_ all: [String]) -> Ingredients {
    
    let veggieSet: Set<String> = ["onion", "tomato", "potato", "carrot", "peas"]
    let fruitSet: Set<String> = ["apple", "banana", "mango"]
    let spiceSet: Set<String> = ["salt", "pepper", "coriander", "garam masala", "turmeric"]
    let dairySet: Set<String> = ["milk", "cheese", "butter", "paneer"]
    
    var ingredients = Ingredients() 

    for item in Set(all) {
        if veggieSet.contains(item) {
            ingredients.veggies.append(item)
        } else if fruitSet.contains(item) {
            ingredients.fruits.append(item)
        } else if spiceSet.contains(item) {
            ingredients.spices.append(item)
        } else if dairySet.contains(item) {
            ingredients.dairy.append(item)
        } else {
            ingredients.others.append(item)
        }
    }

    return ingredients
}
