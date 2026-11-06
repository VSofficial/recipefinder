//
//  Tools.swift
//  recipefinder
//
//  Created by Varun Sharma on 20/03/26.
//

import SwiftUI
import Foundation

func performSearch(searchText: String, source: [String]) -> [String] {
    let query = normalizeIngredient(cleanIngredient(searchText))
    
    if query.isEmpty {
        return source
    }
    
    return source.filter { item in
        let normalizedItem = normalizeIngredient(cleanIngredient(item))
        
        return normalizedItem.contains(query) ||
               query.contains(normalizedItem)
    }
}


enum SortOption: String, CaseIterable {
    case name = "Name"
    case dateAdded = "Date Added"
    case expiryDate = "Expiry Date"
}

struct FilterMenuExample: View {
    @State private var selectedSort: SortOption = .name

    var body: some View {
        HStack {
            
            Menu {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Button {
                        selectedSort = option
                    } label: {
                        Label(option.rawValue, systemImage: selectedSort == option ? "checkmark" : "")
                    }
                }
            } label : {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
             .frame(width: 45, height:45)
            .foregroundStyle(Color.white)
            .font(Font.title2.bold())
            .background(Color.brown)
            .clipShape(Capsule())
            .padding(2)
            
        }
   
    }
}
