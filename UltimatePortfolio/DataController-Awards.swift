//
//  DataController-Awards.swift
//  UltimatePortfolio
//
//  Created by Philipp on 04.07.21.
//

import Foundation
import CoreData

extension DataController {
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            // returns true if they added a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "complete":
            // returns true if they completed a certain number of items
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "chat":
            // return true if they posted a certain number of chat messages
            return UserDefaults.standard.integer(forKey: "chatCount") >= award.value

        default:
            // an unknown award criterion, this should never be allowed
            // fatalError("Unknown award criterion: \(award.criterion)")
            return false
        }
    }
}
