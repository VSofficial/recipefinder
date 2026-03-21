//
//  RecipeView.swift
//  recipefinder
//
//  Created by Varun Sharma on 19/03/26.
//

import SwiftUI

struct RecipeView: View {
    let recipes = loadRecipes() ?? []
 
   // @State var selectedRecipe: Recipe?
    var body: some View {
        List(recipes, id: \.translatedRecipeName) { item in
                   Text(item.translatedRecipeName)
               }
    }
}

#Preview {
    RecipeView()
}
