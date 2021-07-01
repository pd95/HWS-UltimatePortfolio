//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by Philipp on 01.07.21.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

class PerformanceTests: BaseTestCase {

    func testAwardCalculationPerformance() throws {
        // Create a significant amount of test data
        for _ in 0..<100 {
            try dataController.createSampleData()
        }

        // Simulate lots of awards to check
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks awards count is constant. Change this if you add new awards.")

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }

}
