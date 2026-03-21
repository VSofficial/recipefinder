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
    @State private var path = NavigationPath()
    @State private var checkedItems: [String: Bool] = [:]
    @State private var selectedItems: Set<String> = []
    @State private var searchText = ""
    @State private var debouncedSearch = ""
    @State private var ingredients = Ingredients()
    
    
    //@State private var searchText = ""
   // @State private var debouncedSearch = ""
   // @State private var ingredients = Ingredients()
    @State private var filteredIngredients: [String] = []
    
    
//    var filteredIngredients: [String] {
//        if searchText.isEmpty {
//            return ingredients.others
//        } else {
//            return ingredients.others.filter {
//                $0.localizedCaseInsensitiveContains(searchText)
//            }
//        }
//    }
//    
//    var filteredIngredients: [String] {
//        let base = searchText.isEmpty
//            ? ingredients.others
//            : ingredients.others.filter {
//                $0.localizedCaseInsensitiveContains(searchText)
//            }
//        
//        return Array(base.prefix(100)) // 👈 limit
//    }
    
//    var filteredIngredients: [String] {
//        let search = debouncedSearch
//            .lowercased()
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        if search.isEmpty {
//            return Array(ingredients.others.prefix(20))
//        }
//
//        var result: [String] = []
//
//        for item in ingredients.others {
//            if item.hasPrefix(search) {
//                result.insert(item, at: 0) // prioritize
//            } else if item.contains(search) {
//                result.append(item)
//            }
//
//            if result.count >= 20 { break }
//        }
//
//        return result
//    }
    
    var body: some View {
        
       
        NavigationStack() {
        //@State var isChecked:Bool = true
            VStack(spacing:30) {
                Text("Your Pantry")
//                NavigationLink("Open Detail", destination: ContentView3(selectedItems: selectedItems))
                NavigationLink("Open Detail") {
                    ContentView3(selectedItems: selectedItems)
                }
                
                TextField("Search ingredients...", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onSubmit(of: .search) {
                        DispatchQueue.global(qos: .userInitiated).async {
                            
                            let result = performSearch(
                                searchText: searchText,
                                source: ingredients.others
                            )

                            DispatchQueue.main.async {
                                self.filteredIngredients = result
                            }
                        }
                    }
                
//                List {
//                    Section(
//                        header:
//                            Text("Veggies")
//                            .font(Font.largeTitle)
//                            .foregroundColor(.orange)
//                    ) {
//                        
//                        
//                        ForEach(filteredIngredients, id: \.self) { item in
//                            HStack() {
//                                Image(systemName: "carrot.fill")
//                                    .font(Font.largeTitle)
//                                    .foregroundColor(.orange.opacity(0.8))
//                                VStack {
//                                    Text(item)
//                                    //Text("Gajar")
//                                    
//                                }
//                                
//                                Spacer()
//                                
//                               // CheckboxView(isChecked: $checked)
////                                CheckboxView(
////                                    isChecked: Binding(
////                                        get: { checkedItems[item] ?? false },
////                                        set: { checkedItems[item] = $0 }
////                                    )
////                                )
//                                CheckboxView(
//                                    isChecked: Binding(
//                                        get: { selectedItems.contains(item) },
//                                        set: { value in
//                                            if value {
//                                                selectedItems.insert(item)
//                                            } else {
//                                                selectedItems.remove(item)
//                                            }
//                                        }
//                                    )
//                                )
//                                
//                            }
//                            .listRowBackground(Color(.white))
//                            .padding(.vertical, 4)
//                            
//                            
//                        }
//                        
//                    }
//                    
////                    Section(header:
////                                Text("Fruits")
////                        .font(Font.largeTitle)
////                        .foregroundColor(.orange)
////                    ) {
////                        ForEach(ingredients.fruits, id: \.self) { item in
////                            HStack {
////                                Image(systemName: "cup.and.saucer.fill")
////                                    .font(Font.largeTitle)
////                                    .foregroundColor(.brown)
////                                VStack {
////                                    Text(item)
////                                    Text("Gajar")
////                                }
////                                
////                                Spacer()
////                                
////                                //CheckboxView(isChecked: $checked)
////                                CheckboxView(
////                                    isChecked: Binding(
////                                        get: { checkedItems[item] ?? false },
////                                        set: { checkedItems[item] = $0 }
////                                    )
////                                )
////                            }
////                            .listRowBackground(Color(.white))
////                            .padding(.vertical, 4)
////                            // .padding(.leading, 0)
////                            
////                        }
////                        
////                    }
////                    
////                    Section(header:
////                                Text("Spices")
////                        .font(Font.largeTitle)
////                        .foregroundColor(.orange)
////                    ) {
////                        ForEach(ingredients.spices, id: \.self) { item in
////                            HStack {
////                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
////                                    .font(Font.largeTitle)
////                                    .foregroundColor(.yellow)
////                                VStack {
////                                    Text(item)
////                                    Text("Gajar")
////                                }
////                                
////                                Spacer()
////                                
////                                //CheckboxView(isChecked: $checked)
////                                CheckboxView(
////                                    isChecked: Binding(
////                                        get: { checkedItems[item] ?? false },
////                                        set: { checkedItems[item] = $0 }
////                                    )
////                                )
////                            }
////                            .listRowBackground(Color(.white))
////                            .padding(.vertical, 4)
////                            // .padding(.leading, 0)
////                            
////                        }
////                        
////                    }
////                    
////                    Section(header:
////                        Text("Others")
////                            .font(.largeTitle)
////                            .foregroundColor(.orange)
////                    ) {
////                        ForEach(ingredients.others, id: \.self) { item in
////                            Text(item)
////                        }
////                    }
//                    
//                }
//                
//                .scrollContentBackground(.hidden)
//                .listStyle(.plain)
//                .searchable(text: $searchText, prompt: "Search ingredients...")
//                //.background(Color.white)
//                //.padding(EdgeInsets(top: 0, leading: -35, bottom: 0, trailing: -35))
//                //.id(debouncedSearch)
//
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
            
          //  .searchable(text: $searchText)
//            .onAppear {
//                let recipeModels = loadRecipes() ?? []
//                let allIngredients = extractAllIngredients(from: recipeModels)
//
//                ingredients = categorizeIngredients(allIngredients)
//
//                filteredIngredients = performSearch(
//                    searchText: "",
//                    source: ingredients.others
//                )
//            }
            
            .onAppear {
                let recipeModels = loadRecipes() ?? []
                let allIngredients = extractAllIngredients(from: recipeModels)

                ingredients = categorizeIngredients(allIngredients)

                // normalize once
                ingredients.others = ingredients.others.map { $0.lowercased() }

                filteredIngredients = performSearch(
                    searchText: "",
                    source: ingredients.others
                )
                
                print("Count:", ingredients.others.count)
            }
           
            .onSubmit(of: .search) {
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    let result = performSearch(
                        searchText: searchText,
                        source: ingredients.others
                    )

                    DispatchQueue.main.async {
                        self.filteredIngredients = result
                    }
                }
            }
            
            
          
        }
        .padding()
        
        
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

