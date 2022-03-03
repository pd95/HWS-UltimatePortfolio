//
//  PlatformAdjustments.swift
//  UltimatePortfolioMac
//
//  Created by Philipp on 28.02.22.
//

import SwiftUI
import CloudKit

typealias UIApplication = NSApplication
typealias UIColor = NSColor

typealias ImageButtonStyle = BorderlessButtonStyle

extension ListStyle where Self == SidebarListStyle {
    public static var myGrouped: SidebarListStyle {
        SidebarListStyle()
    }
}

extension Notification.Name {
    static let willResignActive = NSApplication.willResignActiveNotification
}


struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0, content: content)
    }
}

extension CKContainer {
    static func `default`() -> CKContainer {
        return CKContainer(identifier: "iCloud.com.yourcompany.UltimatePortfolio")
    }
}
