//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI

struct ContentView3: View {
    
    
    //let recipes1 = loadRecipes() ?? []
    let recipes = (loadRecipes() ?? []).map { $0.toRecipe() }
    
    //var selectedItems: [String: Bool]
    var selectedItems: Set<String>
    @State private var isOn = false
    
//    var filteredRecipes: [Recipe] {
//        recipes.filter { recipe in
//            let recipeIngredients = recipe.ingredients
//
//            if isOn {
//                return recipeIngredients.allSatisfy {
//                    selectedIngredients.contains($0)
//                }
//            } else {
//                return recipeIngredients.contains {
//                    selectedIngredients.contains($0)
//                }
//            }
//        }
//    }
    
    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            let recipeIngredients = recipe.ingredients
            
            let matchCount = recipeIngredients.filter {
                selectedIngredients.contains($0)
            }.count
            
            if isOn {
                // strict mode (all ingredients must match)
                return matchCount == recipeIngredients.count
            } else {
                // relaxed mode (at least 4 matches)
                return matchCount >= 4
            }
        }
    }

    var selectedIngredients: [String] {
        selectedItems.map { normalizeIngredient($0) }
    }
    
    var body: some View {
        VStack() {
        Text("Recipe Matches")
                .font(.title)
        
            Spacer(minLength: 30)
            
            HStack() {
                VStack {
                    Text("Strict Match Only")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .opacity(0.9)
                        
                    Text("Using only items you have")
                        .font(.system(size: 14))
                        //.fontWeight(.semibold)
                        .opacity(0.8)
                    
                }
                
                Toggle("", isOn: $isOn)
                    .tint(Color.orange)
                
                Spacer()
            }
            .padding()
            
            Divider()
            
            List {
                ForEach(filteredRecipes, id:\.self) { item in
                    
                    let isFullMatch = item.ingredients.allSatisfy {
                           selectedIngredients.contains($0)
                       }
                       
                   
                    
                    HStack {
                        
                        Image("roti")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.orange.opacity(0.8))
                        
                        VStack(alignment: .leading) {
                            Text(""+item.name)
                                .font(.system(size: 18))
                            
                            HStack {
                                Text(String(selectedItems.count ?? 0) + "/" + String(item.ingredients.count))
                                Text("ingredients")
                                //Text(String(filteredRecipes.count ?? 0))
                            }
                            .padding(6)
                            .background(.yellow.opacity(0.2))
                            .clipShape(.capsule)
                           
                            
                    
                        }
                        .padding(6)
                    
                        
                        Spacer()
                        
                        Image(systemName: isFullMatch ? "checkmark.circle.fill" : "exclamationmark.circle")
                            .font(.title)
                            .foregroundColor(isFullMatch ? .green : .orange)
                    
                        
                    }
                    .listRowBackground(Color.orange.opacity(0.1))
                  
                }
                
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
          
        
        Spacer()
            
        }
       // .padding()
    }
    
}

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


//extension RecipeModelElement {
//    func toRecipe() -> Recipe {
//        let ingredientsArray = cleanedIngredients
//            .lowercased()
//            .components(separatedBy: ",")
//            //.map { cleanIngredient($0) }
//            .map { normalizeIngredient(cleanIngredient($0)) }
//            .filter { !$0.isEmpty }
//
//        return Recipe(
//            name: translatedRecipeName,
//            ingredients: ingredientsArray,
//            description: translatedInstructions
//        )
//    }
//}




#Preview {
    ContentView3(selectedItems: ["tomato","potato","salt","oil"])
}
