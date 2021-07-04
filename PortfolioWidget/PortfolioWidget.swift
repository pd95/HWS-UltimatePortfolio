//
//  PortfolioWidget.swift
//  PortfolioWidget
//
//  Created by Philipp on 04.07.21.
//

import WidgetKit
import SwiftUI

@main
struct PortfolioWidgets: WidgetBundle {
    var body: some Widget {
        SimplePortfolioWidget()
        ComplexPortfolioWidget()
    }
}
