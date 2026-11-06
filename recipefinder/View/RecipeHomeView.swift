////
////  ContentView.swift
////  recipefinder
////
////  Created by Varun Sharma on 07/03/26.
////
//
//import SwiftUI
//import SwiftData
//
//struct RecipeHome: View {
//    @State private var viewModel = RecipeHomeViewModel()
//    @Environment(\.modelContext) private var context
//    
//    var body: some View {
//        @Bindable var vm = viewModel
//        
//        NavigationStack(path: $vm.path) {
//            VStack(spacing: 15) {
//                
//                HStack {
//                    Text("Your Pantry")
//                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
//                }
//                .font(Font.title2.bold())
//                .foregroundStyle(Color.brown)
//                .symbolRenderingMode(.hierarchical)
//                
//                ZStack {
//                    // Centered button - centers relative to full width
//                    Button {
//                        viewModel.goToRecipes()
//                    } label: {
//                        HStack {
//                            Text("Go to Recipes")
//                            Image(systemName: "arrow.right.circle")
//                        }
//                    }
//                    .padding(10)
//                    .foregroundStyle(Color.white)
//                    .font(Font.title3.bold())
//                    .background(Color.brown)
//                    .clipShape(Capsule())
//                    
//                    // Leading-aligned filter menu, overlaid on top
//                    HStack {
//                        FilterMenuExample()
//                        Spacer()
//                    }
//                }
//                .frame(minHeight: 0)
//                .padding(.horizontal)
//          
//                
//                ScrollView(.horizontal) {
//                    
//                    LazyHStack(spacing: 10) {
//                        ForEach(Array(viewModel.selectedItems), id: \.self) { item in
//                            HStack(spacing: 8) {
//                                Text(item)
//                                    .font(.system(size: 20))
//                                
//                                Image(systemName: "x.circle")
//                                    .resizable()
//                                    .frame(width: 22, height: 22)
//                                    .foregroundColor(.black.opacity(0.8))
//                                    .onTapGesture {
//                                        viewModel.removeFromSelection(item)
//                                    }
//                            }
//                            .padding(.horizontal, 15)
//                            .padding(.vertical, 8)
//                            .background(Color.yellow.opacity(0.2))
//                            .clipShape(Capsule())
//                        }
//                        
//                        
//                    }
//                    .padding(10)
//                }
//                .fixedSize(horizontal: false, vertical: true)
//                .scrollIndicators(.hidden)
//                
//                
//                ScrollView {
//                    LazyVStack(spacing: 10) {
//                        ForEach(viewModel.filteredIngredients, id: \.self) { item in
//                            
//                            HStack {
//                                Image("veggie")
//                                    .resizable()
//                                    .frame(width: 40, height: 40)
//                                    .foregroundColor(.orange.opacity(0.8))
//                                
//                                Text(item)
//                                
//                                if viewModel.isInFridge(item) {
//                                    Image(systemName: "refrigerator.fill")
//                                        .font(.title3)
//                                        .foregroundStyle(.brown)
//                                }
//                                
//                                Spacer()
//                                
//                                CheckboxView(
//                                    isChecked: Binding(
//                                        get: { viewModel.isSelected(item) },
//                                        set: { viewModel.toggleSelection(item, isOn: $0) }
//                                    )
//                                )
//                            }
//                            .padding()
//                            .background(.yellow.opacity(0.10))
//                            .cornerRadius(10)
//                        }
//                    }
//                    .padding()
//                }
//                Spacer()
//            }
//            .onAppear {
//                viewModel.onAppear()
//            }
//            .searchable(text: $vm.searchText, prompt: "Search ingredients...")
//            .padding()
//            .navigationDestination(for: Route.self) { route in
//                switch route {
//                case .content3:
//                    RecipeMatchView(selectedItems: viewModel.selectedItems)
//                   
//                    
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink {
//                        InventoryView()
//                    } label: {
//                        Text("Inventory")
//                            .foregroundStyle(Color.brown)
//                            .fontWeight(.medium)
//                        Image(systemName: "refrigerator.fill")
//                            .foregroundStyle(Color.brown)
//                    }
//                }
//                
//                ToolbarItem(placement: .topBarLeading) {
//                    NavigationLink {
//                        // InventoryView()
//                        AboutView()
//                    } label: {
//                        Image(systemName: "camera.macro")
//                            .foregroundStyle(Color.pink).opacity(0.8)
//                        Text("About")
//                            .foregroundStyle(Color.pink).opacity(0.8)
//                            .fontWeight(.medium)
//                        
//                    }
//                }
//                
//                
//            }
//            .background(.yellow.opacity(0.15))
//        }
//    }
//}
//
////#Preview {
////    RecipeHome()
////}
//
//#Preview {
//    RecipeHome()
//        .modelContainer(for: RecipeStored.self, inMemory: true)
//}
//
//
//struct CheckboxView: View {
//    @Binding var isChecked: Bool
//    
//    var body: some View {
//        Button {
//            isChecked.toggle()
//        } label: {
//            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
//                .foregroundStyle(Color.orange)
//                .font(Font.system(size: 30))
//        }
//    }
//}
//
//struct IngredientRow: View {
//    let item: String
//    let isInFridge: Bool
//    let isSelected: Bool
//    let onToggle: (Bool) -> Void
//
//    var body: some View {
//        HStack {
//            Image("veggie")
//                .resizable()
//                .frame(width: 40, height: 40)
//                .foregroundColor(.orange.opacity(0.8))
//            Text(item)
//            if isInFridge {
//                Image(systemName: "refrigerator.fill")
//                    .font(.title3)
//                    .foregroundStyle(.brown)
//            }
//            Spacer()
//            CheckboxView(isChecked: Binding(
//                get: { isSelected },
//                set: { onToggle($0) }
//            ))
//        }
//        .padding()
//        .background(.yellow.opacity(0.10))
//        .cornerRadius(10)
//    }
//}

//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI
import SwiftData

struct RecipeHome: View {
    @State private var viewModel = RecipeHomeViewModel()
    @Environment(\.modelContext) private var context

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack(path: $vm.path) {
            VStack(spacing: 15) {
                header
                actionBar
                selectedChips
                ingredientList
                Spacer()
            }
            .onAppear { viewModel.onAppear() }
            .task { seedRecipesIfNeeded(context: context) }
            .searchable(text: $vm.searchText, prompt: "Search ingredients...")
            .padding()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .content3:
                    RecipeMatchView(selectedItems: viewModel.selectedItems, context: context)
                }
            }
            .toolbar { toolbarContent }
            .background(.yellow.opacity(0.15))
        }
    }

    // MARK: - Extracted subviews (each is now its own type-check unit)

    private var header: some View {
        HStack {
            Text("Your Pantry")
            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
        }
        .font(Font.title2.bold())
        .foregroundStyle(Color.brown)
        .symbolRenderingMode(.hierarchical)
    }

    private var actionBar: some View {
        ZStack {
            Button {
                viewModel.goToRecipes()
            } label: {
                HStack {
                    Text("Go to Recipes")
                    Image(systemName: "arrow.right.circle")
                }
            }
            .padding(10)
            .foregroundStyle(Color.white)
            .font(Font.title3.bold())
            .background(Color.brown)
            .clipShape(Capsule())

            HStack {
                FilterMenuExample()
                Spacer()
            }
        }
        .frame(minHeight: 0)
        .padding(.horizontal)
    }

    private var selectedChips: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(Array(viewModel.selectedItems), id: \.self) { item in
                    SelectedItemChip(item: item) {
                        viewModel.removeFromSelection(item)
                    }
                }
            }
            .padding(10)
        }
        .fixedSize(horizontal: false, vertical: true)
        .scrollIndicators(.hidden)
    }

    private var ingredientList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.filteredIngredients, id: \.self) { item in
                    IngredientRow(
                        item: item,
                        isInFridge: viewModel.isInFridge(item),
                        isSelected: viewModel.isSelected(item),
                        onToggle: { viewModel.toggleSelection(item, isOn: $0) }
                    )
                }
            }
            .padding()
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
                InventoryView()
            } label: {
                Text("Inventory")
                    .foregroundStyle(Color.brown)
                    .fontWeight(.medium)
                Image(systemName: "refrigerator.fill")
                    .foregroundStyle(Color.brown)
            }
        }
        ToolbarItem(placement: .topBarLeading) {
            NavigationLink {
                AboutView()
            } label: {
                Image(systemName: "camera.macro")
                    .foregroundStyle(Color.pink).opacity(0.8)
                Text("About")
                    .foregroundStyle(Color.pink).opacity(0.8)
                    .fontWeight(.medium)
            }
        }
    }
}

#Preview {
    RecipeHome()
        .modelContainer(for: RecipeStored.self, inMemory: true)
}

struct CheckboxView: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button {
            isChecked.toggle()
        } label: {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundStyle(Color.orange)
                .font(Font.system(size: 30))
        }
    }
}

struct IngredientRow: View {
    let item: String
    let isInFridge: Bool
    let isSelected: Bool
    let onToggle: (Bool) -> Void

    var body: some View {
        HStack {
            Image("veggie")
                .resizable()
                .frame(width: 40, height: 40)
                .foregroundColor(.orange.opacity(0.8))
            Text(item)
            if isInFridge {
                Image(systemName: "refrigerator.fill")
                    .font(.title3)
                    .foregroundStyle(.brown)
            }
            Spacer()
            CheckboxView(isChecked: Binding(
                get: { isSelected },
                set: { onToggle($0) }
            ))
        }
        .padding()
        .background(.yellow.opacity(0.10))
        .cornerRadius(10)
    }
}

struct SelectedItemChip: View {
    let item: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Text(item)
                .font(.system(size: 20))
            Image(systemName: "x.circle")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundColor(.black.opacity(0.8))
                .onTapGesture(perform: onRemove)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(Color.yellow.opacity(0.2))
        .clipShape(Capsule())
    }
}
