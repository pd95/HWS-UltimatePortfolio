//
//  PlatformAdjustments.swift
//  UltimatePortfolio
//
//  Created by Philipp on 28.02.22.
//

import Foundation
import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle

extension Notification.Name {
    static let willResignActive = UIApplication.willResignActiveNotification
}

extension ListStyle where Self == InsetGroupedListStyle {
    public static var myGrouped: InsetGroupedListStyle {
        InsetGroupedListStyle()
    }
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationView(content: content)
            .navigationViewStyle(.stack)
    }
}
