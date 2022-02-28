//
//  UltimatePortfolioApp.swift
//  UltimatePortfolio
//
//  Created by Philipp on 30.06.21.
//

import SwiftUI

@main
struct UltimatePortfolioApp: App {
    #if os(iOS)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    @StateObject var dataController: DataController
    @StateObject var unlockManager: UnlockManager
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("lastReviewRequest") var lastReviewRequest: TimeInterval?

    var askForReview: Bool {
        if let lastReviewRequest = lastReviewRequest {
            let lastReviewDistance = Date().timeIntervalSinceReferenceDate - lastReviewRequest
            // Ask only every 5 days for a review
            if  lastReviewDistance < 5*24*60*60 {
                return false
            }
        }
        return true
    }

    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)

        // Workaround for "Sign-in with Apple" not working on simulator: force a specific username
        #if targetEnvironment(simulator)
        UserDefaults.standard.set("TwoStraws", forKey: "username")
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                .onReceive(
                    // Automatically save when we detect that we are no longer
                    // the foreground app. Use this rather thab the scene phase
                    // API so we can port to macOS, where scene phase won't detect
                    // our app losing focus as of macOS 11.1.
                    NotificationCenter.default.publisher(for: .willResignActive),
                    perform: save
                )
                // The following lines to not work as expected...
                // .onAppear(perform: dataController.appLaunched)
                // ... therefore I came up with the "scenePhase" monitoring below
                .onChange(of: scenePhase, perform: { newScenePhase in
                    if newScenePhase == .active && askForReview {
                        lastReviewRequest = Date().timeIntervalSinceReferenceDate
                        dataController.appLaunched()
                    }
                })
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
