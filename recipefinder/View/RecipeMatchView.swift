//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI
import SwiftData

struct RecipeMatchView: View {
    @State private var viewModel: RecipeMatchViewModel

//    init(selectedItems: Set<String>) {
//        _viewModel = State(initialValue: RecipeMatchViewModel(selectedItems: selectedItems))
//    }
    
    init(selectedItems: Set<String>, context: ModelContext) {
            _viewModel = State(initialValue: RecipeMatchViewModel(selectedItems: selectedItems, context: context))
        }

    var body: some View {
        @Bindable var vm = viewModel

        VStack {
            Text("Recipe Matches")
                .font(.title)

            Spacer(minLength: 30)

            HStack {
                VStack {
                    Text("Strict Match Only")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .opacity(0.9)

                    Text("Using only items you have")
                        .font(.system(size: 14))
                        .opacity(0.8)
                }

                Toggle("", isOn: $vm.isStrictMatch)
                    .tint(Color.orange)

                Spacer()
            }
            .padding()

            Divider()

            List {
                ForEach(viewModel.filteredRecipes, id: \.self) { recipe in
                    RecipeMatchRow(
                        recipe: recipe,
                        matchLabel: viewModel.matchCountLabel(for: recipe),
                        isFullMatch: viewModel.isFullMatch(recipe)
                    )
                }
            }
            .scrollContentBackground(.hidden)

            Spacer()
        }
        .background(Color.yellow.opacity(0.15))
    }
}

// MARK: - Row subview

private struct RecipeMatchRow: View {
    let recipe: Recipe
    let matchLabel: String
    let isFullMatch: Bool

    var body: some View {
        HStack {
            Image("roti")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange.opacity(0.8))

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.system(size: 18))

                HStack {
                    
               
                HStack {
                    Text(matchLabel)
                    Text("ingredients")
                }
                .padding(6)
                .background(.yellow.opacity(0.2))
                .clipShape(.capsule)
                
                HStack {
                    Text("Cuisine")
                    
                }
                .padding(4)
                .padding(.leading,6)
                .padding(.trailing,6)
                .background(.yellow.opacity(0.2))
                .clipShape(.capsule)
                }
                
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

//#Preview {
//    RecipeMatchView(selectedItems: ["tomato", "potato", "salt", "oil"])
//}

//#Preview {
//    let container = try! ModelContainer(for: RecipeStored.self, configurations: .init(isStoredInMemoryOnly: true))
//    let context = container.mainContext
//
//    context.insert(RecipeStored(
//        url: "preview-1",
//        name: "Aloo Tomato Sabzi",
//        ingredientsRaw: "tomato, potato, salt, oil",
//        cleanedIngredients: "tomato, potato, salt, oil",
//        instructions: "Preview instructions",
//        cuisine: "Indian",
//        totalTimeInMins: 20,
//        imageURL: "",
//        ingredientCount: 4,
//        normalizedIngredientsCSV: "tomato, potato, salt, oil"
//    ))
//
//    RecipeMatchView(selectedItems: ["tomato", "potato", "salt", "oil"], context: context)
//}

//#Preview {
//    let container = try! ModelContainer(
//        for: RecipeStored.self,
//        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
//    )
//    let context = container.mainContext
//
//    context.insert(RecipeStored(
//        url: "preview-1",
//        name: "Aloo Tomato Sabzi",
//        ingredientsRaw: "tomato, potato, salt, oil",
//        cleanedIngredients: "tomato, potato, salt, oil",
//        instructions: "Preview instructions",
//        cuisine: "Indian",
//        totalTimeInMins: 20,
//        imageURL: "",
//        ingredientCount: 4,
//        normalizedIngredientsCSV: "tomato, potato, salt, oil"
//    ))
//
//    RecipeMatchView(selectedItems: ["tomato", "potato", "salt", "oil"], context: context)
//}

