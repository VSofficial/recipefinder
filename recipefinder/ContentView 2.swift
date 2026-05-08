//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI


struct ContentView2: View {
    
    // var isChecked:Bool = false
    @State private var checked = false
    //@State private var path = NavigationPath()
    @State private var checkedItems: [String: Bool] = [:]
    @State private var selectedItems: Set<String> = []
    @State private var searchText = ""
    @State private var debouncedSearch = ""
    @State private var ingredients = Ingredients()
    @State private var path = [Route]()
    
    @State private var filteredIngredients: [String] = []
    
    let store = IngredientStore.shared
    
    var body: some View {
        
        NavigationStack(path: $path) {
            //@State var isChecked:Bool = true
            
            VStack(spacing:15) {
                
                HStack {
                Text("Your Pantry")
                    Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                }
                .font(Font.title2.bold())
                .foregroundStyle(Color.brown)
                .symbolRenderingMode(.hierarchical)
                
                HStack() {
                    Button("Go to Recipes") {
                        
                        print(selectedItems)
                        // 🧠 ensures single instance
                        if !path.contains(.content3) {
                            path.append(.content3)
                        }
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
                        
                            ForEach(Array(selectedItems), id: \.self) { item in
                                HStack(spacing:8) {
                            
                                    Text(item)
                                        .font(.system(size: 20))
                                    
                                    Image(systemName:"x.circle")
                                        .resizable()
                                        .frame(width: 22, height: 22)
                                        .foregroundColor(.black.opacity(0.8))
                                        .onTapGesture {
                                            selectedItems.remove(item)
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
                        ForEach(filteredIngredients, id: \.self) { item in
                            HStack {
                                //Image(systemName: "carrot.fill")
                                Image("veggie")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                //.font(.largeTitle)
                                    .foregroundColor(.orange.opacity(0.8))
                                
                                Text(item)
                                
                                Spacer()
                                
                                CheckboxView(
                                    isChecked: Binding(
                                        get: { selectedItems.contains(item) },
                                        set: { value in
                                            if value {
                                                selectedItems.insert(item)
                                            } else {
                                                selectedItems.remove(item)
                                            }
                                        }
                                    )
                                )
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
                
                Spacer()
                
            }
            
            .onAppear {

                filteredIngredients = performSearch(
                    searchText: "",
                    source: store.ingredients
                )
                print("Count:", store.ingredients.count)
            }
            
            .searchable(text: $searchText, prompt: "Search ingredients...")
            .onChange(of: searchText) { newValue in
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let result = performSearch(
                        searchText: newValue,
                        source: store.ingredients
                    )
                    
                    DispatchQueue.main.async {
                        self.filteredIngredients = result
                    }
                }
            }
            .padding()
            //.navigationTitle("ContentView2")
            // Destination mapping
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .content3:
                    ContentView3(selectedItems: selectedItems)
                }
            }
            
            .toolbar() {
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
            
        }
    }
}

#Preview {
    ContentView2()
}


struct CheckboxView: View {
    
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundStyle(Color.orange)
                    .font(Font.system(size: 30))
                
            }
        }
    }
}

