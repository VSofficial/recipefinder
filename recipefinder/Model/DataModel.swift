//
//  DataModel.swift
//  recipefinder
//
//  Created by Varun Sharma on 09/03/26.
//
import Foundation

// MARK: - IngredientsList



struct Ingredients {
    var veggies: [String] = []
    var fruits: [String] = []
    var spices: [String] = []
    var dairy: [String] = []
    var others: [String] = []
}

struct Recipe:Hashable {
    var name: String
    var ingredients: [String]
    var description: String
}

var ingredientsExisting = Ingredients(veggies: ["Carrots", "Onions", "Beets"], fruits: ["Apples", "Bananas"], spices: ["Cinnamon", "Coriander"], dairy: ["Cheese"], others: ["Olive Oil", "Garlic"])

var recipes: [Recipe] = [
    Recipe(name: "Dal Tadka", ingredients: ["Carrots", "Coriander"], description: "Dal Tadka Description"),
    Recipe(name: "Gajar Sabji", ingredients: ["Carrots", "Coriander", "Onions"], description: "Gajar Sabji Description"),
 
]
    

enum Route: Hashable {
    case content3
   // case menu
}
