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
//           
//            if isOn {
//                // STRICT MODE → all ingredients must exist
//                return recipeIngredients.allSatisfy { selectedIngredients.contains($0) }
//            } else {
//                // RELAXED MODE → at least one match
//                return recipeIngredients.contains { selectedIngredients.contains($0) }
//            }
//        }
//    }
    
    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            let recipeIngredients = recipe.ingredients

            if isOn {
                return recipeIngredients.allSatisfy {
                    selectedIngredients.contains($0)
                }
            } else {
                return recipeIngredients.contains {
                    selectedIngredients.contains($0)
                }
            }
        }
    }
    
//    var selectedIngredients: [String] {
//        selectedItems.compactMap { $0.value ? $0.key : nil }
//            .map { normalizeIngredient($0) }
//    }
    
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
                        VStack {
                            Text(""+item.name)
                                .font(.system(size: 18))
                                
                            HStack() {
                             //   Text(item.description)
                                
                                //Text("Easy")
                            }
                            
                        }
                        .padding(6)
                        
                        Spacer()
                        
                        Image(systemName: isFullMatch ? "checkmark.circle.fill" : "exclamationmark.circle")
                            .font(.title)
                            .foregroundColor(isFullMatch ? .green : .orange)
                    
                        
                    }
                    .listRowBackground(Color.orange.opacity(0.1))
                    //.listStyle(InsetGroupedListStyle())
                    //.padding(.horizontal, 0)
                 
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
    var cleaned = text.lowercased()
    
    // remove plural 's'
    if cleaned.hasSuffix("s") {
        cleaned.removeLast()
    }
    
    // trim spaces
    cleaned = cleaned.trimmingCharacters(in: .whitespacesAndNewlines)
    
    return cleaned
}

extension RecipeModelElement {
    func toRecipe() -> Recipe {
        let ingredientsArray = cleanedIngredients
            .lowercased()
            .components(separatedBy: ",")
            //.map { cleanIngredient($0) }
            .map { normalizeIngredient(cleanIngredient($0)) }
            .filter { !$0.isEmpty }

        return Recipe(
            name: translatedRecipeName,
            ingredients: ingredientsArray,
            description: translatedInstructions
        )
    }
}




#Preview {
    ContentView3(selectedItems: ["Carrots", "Onions", "Beets"])
}
