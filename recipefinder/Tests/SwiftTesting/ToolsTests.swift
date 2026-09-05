//
//  ToolsTests.swift
//  recipefinderTests
//
//  performSearch(searchText:source:) takes its data source as a parameter,
//  so unlike IngredientStore it's fully unit-testable without touching any
//  bundled resource. Cases below assume plain, already-clean lowercase
//  ingredient strings (no punctuation/parentheticals), since `cleanIngredient`
//  itself isn't part of the uploaded files and is presumed to be a
//  pass-through for input like this.
//

import Testing
@testable import recipefinder

@Suite("performSearch")
struct PerformSearchTests {

    let source = ["tomato", "tomatoes", "onion", "potato", "green pepper", "milk"]

    @Test("empty query returns the full, unfiltered source")
    func emptyQuery_returnsFullSource() {
        let result = performSearch(searchText: "", source: source)
        #expect(result == source)
    }

    @Test("whitespace-only query behaves like an empty query")
    func whitespaceQuery_returnsFullSource() {
        let result = performSearch(searchText: "   ", source: source)
        #expect(result == source)
    }

    @Test("query matches items whose normalized form contains it")
    func query_matchesContainingItems() {
        let result = performSearch(searchText: "tomato", source: source)

        // "tomatoes" normalizes to "tomato" via the plural-stripping rule,
        // so both should match; unrelated items should not.
        #expect(result.contains("tomato"))
        #expect(result.contains("tomatoes"))
        #expect(!result.contains("onion"))
        #expect(!result.contains("milk"))
    }

    @Test("a multi-word query matches an item that is a substring of it")
    func multiWordQuery_matchesSubstringItem() {
        let result = performSearch(searchText: "green pepper", source: ["pepper", "onion"])

        #expect(result.contains("pepper"))
        #expect(!result.contains("onion"))
    }

    @Test("a query with no matches returns an empty array")
    func noMatches_returnsEmpty() {
        let result = performSearch(searchText: "xylophone", source: source)
        #expect(result.isEmpty)
    }

    @Test("search is case-insensitive")
    func query_isCaseInsensitive() {
        let result = performSearch(searchText: "TOMATO", source: source)
        #expect(result.contains("tomato"))
    }
}

@Suite("normalizeIngredient")
struct NormalizeIngredientTests {

    @Test("trims leading and trailing whitespace")
    func trimsWhitespace() {
        #expect(normalizeIngredient("  potato \n") == "potato")
    }

    @Test("words ending in 'ies' become singular 'y'")
    func pluralIES_becomesY() {
        #expect(normalizeIngredient("berries") == "berry")
    }

    @Test("words ending in 'es' drop the 'es'")
    func pluralES_dropsES() {
        #expect(normalizeIngredient("tomatoes") == "tomato")
    }

    @Test("words ending in 's' longer than 3 characters drop the 's'")
    func pluralS_dropsS() {
        #expect(normalizeIngredient("onions") == "onion")
    }

    @Test("short words ending in 's' are left alone")
    func shortWordEndingInS_isUnchanged() {
        // count == 3, so the `count > 3` guard should prevent stripping.
        #expect(normalizeIngredient("gas") == "gas")
    }

    @Test("singular words with no matching suffix are unchanged")
    func singularWord_isUnchanged() {
        #expect(normalizeIngredient("milk") == "milk")
    }
}
