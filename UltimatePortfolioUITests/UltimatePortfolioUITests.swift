//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Philipp on 01.07.21.
//

import XCTest

class UltimatePortfolioUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppHas5Tabs() {
        XCTAssertEqual(app.tabBars.buttons.count, 5, "There should be 5 tabs in the app.")
    }

    func testOpenTabAddsProjects() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1...3 {
            addProjectButton.tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) list row(s).")
        }
    }

    func testAddingItemInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        addProjectButton.tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list row after adding an Item.")
    }

    func testEditingProjectUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        addProjectButton.tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project.")

        editProjectButton.tap()

        let textField = app.textFields["Project name"].firstMatch
        textField.tap()
        textField.typeText(" 2")
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()

        let projectTitleElement = projectTitleElementQuery
            .containing(NSPredicate(format: "label BEGINSWITH[cd] 'New Project 2'"))
            .firstMatch
        XCTAssertTrue(projectTitleElement.exists, "The changed project title should be visible in the list.")
    }

    func testEditingItemUpdatesCorrectly() {
        // Go to "Open" and add one project and one item before the test.
        testAddingItemInsertsRows()

        app.buttons["New Item"].tap()

        let textField = app.textFields["Item name"].firstMatch
        textField.tap()
        textField.typeText(" 2")
        app.buttons["Return"].tap()

        app.buttons["Open Projects"].tap()

        XCTAssertTrue(app.buttons["New Item 2"].exists,
                      "The new item name should be visible in the list.")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()

            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a locked alert showing for awards.")
            app.buttons["OK"].tap()
        }
    }

    // MARK: - Helper

    var addProjectButton: XCUIElement {
        app.buttons.containing(NSPredicate(format: "identifier == 'Add Project' OR label == 'add'")).firstMatch
    }

    var editProjectButton: XCUIElement {
        app.buttons
            .containing(NSPredicate(format: "identifier ENDSWITH 'Edit Project'"))
            .firstMatch
    }

    var projectTitleElementQuery: XCUIElementQuery {
        app.tables.children(matching: .any)
            .containing(NSPredicate(format: "identifier BEGINSWITH[cd] 'Project Title'"))
    }
}
