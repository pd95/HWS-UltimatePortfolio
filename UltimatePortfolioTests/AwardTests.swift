//
//  AwardTests.swift
//  UltimatePortfolioTests
//
//  Created by Philipp on 01.07.21.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

class AwardTests: BaseTestCase {
    let awards = Award.allAwards

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name")
        }
    }

    func testNewUserHasNoAwards() {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards.")
        }
    }

    func testAddingItems() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        for (count, value) in values.enumerated() {
            var items = [Item]()

            for _ in 0..<value {
                let item = Item(context: managedObjectContext)
                items.append(item)
            }

            let matches = awards.filter { award in
                award.criterion == "items" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Adding \(value) items should unlock \(count + 1) awards")

            for item in items {
                dataController.delete(item)
            }
        }
    }

    func testCompletingItems() {
        let values = [1, 10, 20, 50, 100, 250, 500, 1000]
        for (count, value) in values.enumerated() {
            var items = [Item]()

            for _ in 0..<value {
                let item = Item(context: managedObjectContext)
                item.completed = true
                items.append(item)
            }

            let matches = awards.filter { award in
                award.criterion == "complete" && dataController.hasEarned(award: award)
            }

            XCTAssertEqual(matches.count, count + 1, "Completing \(value) items should unlock \(count + 1) awards")

            for item in items {
                dataController.delete(item)
            }
        }
    }
}
