//
//  PlatformAdjustments.swift
//  UltimatePortfolio
//
//  Created by Philipp on 28.02.22.
//

import Foundation
import SwiftUI

extension Notification.Name {
    static let willResignActive = UIApplication.willResignActiveNotification
}

extension ListStyle where Self == InsetGroupedListStyle {
    public static var myGrouped: InsetGroupedListStyle {
        InsetGroupedListStyle()
    }
}
