//
//  Error-CloudKitMessages.swift
//  Error-CloudKitMessages
//
//  Created by Philipp on 14.09.21.
//

import CloudKit
import Foundation

extension Error {
    func getCloudKitError() -> CloudError {
        guard let error = self as? CKError else {
            return "An unknown error occurred: \(self.localizedDescription)"
        }
        switch error.code {
        case .badDatabase, .badContainer, .invalidArguments:
            return "A fatal error occurred: \(error.localizedDescription)"
        case .networkFailure, .networkUnavailable, .serverResponseLost, .serviceUnavailable:
            return "There was a problem communicating with iCloud; please check your network connection and try again."
        case .notAuthenticated:
            return "There was a problem with your iCloud account; please check that you're logged in to iCloud."
        case .requestRateLimited:
            return "You've hit iCloud's rate limit; please wait a moment then try again."
        case .quotaExceeded:
            return "You've exceeded your iCloud quota; please clear up some space then try again."
        default:
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
