//
//  PlatformAdjustments.swift
//  UltimatePortfolio
//
//  Created by Philipp on 28.02.22.
//

import Foundation
import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle
typealias MacOnlySpacer = EmptyView

extension Notification.Name {
    static let willResignActive = UIApplication.willResignActiveNotification
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationView(content: content)
            .navigationViewStyle(.stack)
    }
}

extension Section where Parent: View, Content: View, Footer: View {
    func disableCollapsing() -> some View {
        self
    }
}

extension View {
    public func onDeleteCommand(perform action: (() -> Void)?) -> some View {
        self
    }

    func macOnlyPadding() -> some View {
        self
    }
}
