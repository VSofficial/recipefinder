//
//  TestSupport.swift
//  recipefinderTests
//
//  Shared helpers for isolating tests from real persisted state.
//

import Foundation

/// Creates a fresh, isolated UserDefaults suite so tests never read/write
/// the app's real `.standard` defaults and never leak state between tests.
func makeIsolatedDefaults(named id: String = UUID().uuidString) -> UserDefaults {
    let suiteName = "com.recipefinder.tests.\(id)"
    let defaults = UserDefaults(suiteName: suiteName)!
    defaults.removePersistentDomain(forName: suiteName)
    return defaults
}
