//
//  AssetsTest.swift
//  UltimatePortfolioTests
//
//  Created by Philipp on 01.07.21.
//

import XCTest
@testable import UltimatePortfolio

class AssetsTest: XCTestCase {

    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }

    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }
}
