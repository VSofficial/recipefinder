//
//  Tools.swift
//  recipefinder
//
//  Created by Varun Sharma on 20/03/26.
//

import SwiftUI
import Foundation

func performSearch(searchText: String, source: [String]) -> [String] {
    
    let search = searchText.lowercased()

    if search.isEmpty {
        return Array(source.prefix(40)) 
    }

    var result: [String] = []

    for item in source {
        if item.hasPrefix(search) {
            result.insert(item, at: 0)
        } else if item.contains(search) {
            result.append(item)
        }

        if result.count >= 40 { break }
    }

    return result
}
