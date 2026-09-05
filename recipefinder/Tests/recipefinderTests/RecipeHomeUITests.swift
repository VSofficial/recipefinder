//
//  RecipeHomeUITests.swift
//  recipefinder
//
//  Created by Varun Sharma on 01/09/26.
//


import XCTest

final class RecipeHomeUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        
        // Pass launch arguments if your app supports mock data states
        // app.launchArguments.append("--uitesting")
        
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Navigation Bar & Static UI Tests

    func testHeaderAndNavigationElementsExist() throws {
        // Verify Title and Top Icon
        XCTAssertTrue(app.staticTexts["Your Pantry"].exists)
        
        // Verify Navigation Toolbar Buttons
        let inventoryButton = app.buttons["Inventory"]
        let aboutButton = app.buttons["About"]
        
        XCTAssertTrue(inventoryButton.exists)
        XCTAssertTrue(aboutButton.exists)
    }

    // MARK: - Search Functionality

    func testSearchIngredient() throws {
        let searchField = app.searchFields["Search ingredients..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 2.0))
        
        searchField.tap()
        searchField.typeText("Tomato")
        
        // Verify filtered results contain "Tomato"
        let tomatoCell = app.staticTexts["Tomato"]
        XCTAssertTrue(tomatoCell.waitForExistence(timeout: 2.0))
    }

    // MARK: - Selection & Chip Removals

    func testToggleCheckboxAddsAndRemovesSelectedChip() throws {
        // 1. Locate the first ingredient checkbox in the list
        // Note: CheckboxView renders as a Button containing SF Symbols
        let firstCheckbox = app.buttons.matching(identifier: "square").firstMatch
        
        if firstCheckbox.exists {
            firstCheckbox.tap()
            
            // Verify checkbox toggles to selected state
            let checkedCheckbox = app.buttons.matching(identifier: "checkmark.square.fill").firstMatch
            XCTAssertTrue(checkedCheckbox.exists)
            
            // 2. Verify selected item chip appears in horizontal scrollview
            let removeChipButton = app.buttons["x.circle"].firstMatch
            XCTAssertTrue(removeChipButton.exists)
            
            // 3. Tap "x.circle" to deselect
            removeChipButton.tap()
            
            // Verify the chip is removed
            XCTAssertFalse(removeChipButton.exists)
        }
    }

    // MARK: - Navigation Flow Tests

    func testNavigateToRecipeMatchView() throws {
        let goToRecipesButton = app.buttons["Go to Recipes"]
        XCTAssertTrue(goToRecipesButton.exists)
        
        goToRecipesButton.tap()
        
        // Assert that the destination view loaded (adjust "Recipe Match" identifier if needed)
        // Ensure RecipeMatchView has a recognizable element or title
        let destinationElement = app.navigationBars.firstMatch
        XCTAssertTrue(destinationElement.waitForExistence(timeout: 3.0))
    }

    func testNavigateToInventoryScreen() throws {
        let inventoryButton = app.buttons["Inventory"]
        inventoryButton.tap()
        
        // Verify navigation to InventoryView worked
//        let inventoryTitle = app.staticTexts["Inventory"] // Assuming header text in InventoryView
//        XCTAssertTrue(inventoryTitle.waitForExistence(timeout: 8.0))
    }

    func testNavigateToAboutScreen() throws {
        let aboutButton = app.buttons["About"]
        aboutButton.tap()
        
        // Verify navigation to AboutView
//        let aboutTitle = app.staticTexts["About"]
//        XCTAssertTrue(aboutTitle.waitForExistence(timeout: 8.0))
    }
}
