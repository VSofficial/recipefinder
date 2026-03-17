//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI

struct ContentView3: View {
    
    
    var selectedItems: [String: Bool]
    @State private var isOn = false
    
    var filteredRecipes: [Recipe] {
        recipes.filter { recipe in
            let recipeIngredients = recipe.ingredients
            
           
            if isOn {
                // STRICT MODE → all ingredients must exist
                return recipeIngredients.allSatisfy { selectedIngredients.contains($0) }
            } else {
                // RELAXED MODE → at least one match
                return recipeIngredients.contains { selectedIngredients.contains($0) }
            }
        }
    }
    
    var selectedIngredients: [String] {
        selectedItems.compactMap { $0.value ? $0.key : nil }
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
            
            Divider()
            
            List {
                ForEach(filteredRecipes, id:\.self) { item in
                    
                    let isFullMatch = item.ingredients.allSatisfy {
                           selectedIngredients.contains($0)
                       }
                       
                    
                    HStack {
                        Image(systemName: "carrot.fill")
                            .font(Font.largeTitle)
                            .foregroundColor(.orange.opacity(0.8))
                        VStack {
                            Text(item.name)
                                .font(.system(size: 18))
                                
                            HStack() {
                                Text(item.description)
                                //Text("Easy")
                            }
                            
                        }
                        
                        Spacer()
                        
                        Image(systemName: isFullMatch ? "checkmark.circle.fill" : "exclamationmark.circle")
                            .font(.title)
                            .foregroundColor(isFullMatch ? .green : .orange)
                    
                        
                    }
                    .listRowBackground(Color(.systemGray6))
                    .padding(.vertical, 4)
                 
                }
                
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
          
        
        Spacer()
            
        }
        .padding()
    }
    
}


#Preview {
    ContentView3(selectedItems: ["Carrots":true, "Onions":true, "Beets":true])
}

