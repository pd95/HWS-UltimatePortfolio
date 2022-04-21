//
//  PlatformAdjustments.swift
//  UltimatePortfolioMac
//
//  Created by Philipp on 28.02.22.
//

import SwiftUI
import CloudKit

typealias InsetGroupedListStyle = SidebarListStyle
typealias ImageButtonStyle = BorderlessButtonStyle
typealias MacOnlySpacer = Spacer

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

extension Section where Parent: View, Content: View, Footer: View {
    func disableCollapsing() -> some View {
        self.collapsible(false)
    }
}

extension View {
    func macOnlyPadding() -> some View {
        self.padding()
    }
}
