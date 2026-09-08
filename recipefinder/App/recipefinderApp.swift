//
//  recipefinderApp.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI
import SwiftData

//@main
//struct recipefinderApp: App {
//    var body: some Scene {
//        WindowGroup {
//            RecipeHome()
//        }
//    }
//}

@main
struct recipeFinderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: RecipeStored.self)
    }
}
