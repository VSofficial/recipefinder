//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI

struct RecipeHome: View {
    @State private var viewModel = RecipeHomeViewModel()

    var body: some View {
        @Bindable var vm = viewModel

        NavigationStack(path: $vm.path) {
            VStack(spacing: 15) {

                HStack {
                    Text("Your Pantry")
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                }
                .font(Font.title2.bold())
                .foregroundStyle(Color.brown)
                .symbolRenderingMode(.hierarchical)

                HStack {
                    Button("Go to Recipes") {
                        viewModel.goToRecipes()
                    }
                    Image(systemName: "arrow.right.circle")
                }
                .padding(10)
                .foregroundStyle(Color.white)
                .font(Font.title3.bold())
                .background(Color.brown)
                .clipShape(Capsule())

                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(Array(viewModel.selectedItems), id: \.self) { item in
                            HStack(spacing: 8) {
                                Text(item)
                                    .font(.system(size: 20))

                                Image(systemName: "x.circle")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.black.opacity(0.8))
                                    .onTapGesture {
                                        viewModel.removeFromSelection(item)
                                    }
                            }
                            .padding(.horizontal, 15)
                            .padding(.vertical, 8)
                            .background(Color.yellow.opacity(0.2))
                            .clipShape(Capsule())
                        }
                    }
                    .padding(10)
                }
                .fixedSize(horizontal: false, vertical: true)
                .scrollIndicators(.hidden)

                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.filteredIngredients, id: \.self) { item in
                            HStack {
                                Image("veggie")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.orange.opacity(0.8))

                                Text(item)

                                Spacer()

                                CheckboxView(
                                    isChecked: Binding(
                                        get: { viewModel.isSelected(item) },
                                        set: { viewModel.toggleSelection(item, isOn: $0) }
                                    )
                                )
                            }
                            .padding()
                            .background(.yellow.opacity(0.10))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .onAppear {
                viewModel.onAppear()
            }
            .searchable(text: $vm.searchText, prompt: "Search ingredients...")
            .padding()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .content3:
                    RecipeMatchView(selectedItems: viewModel.selectedItems)
                }
            }
            .toolbar {
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
            }
            .background(.yellow.opacity(0.15))
        }
    }
}

#Preview {
    RecipeHome()
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
