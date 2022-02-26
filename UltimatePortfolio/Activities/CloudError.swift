//
//  CloudError.swift
//  CloudError
//
//  Created by Philipp on 14.09.21.
//

import SwiftUI

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String

    init(stringLiteral value: String) {
        self.message = value
    }
}
