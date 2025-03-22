//
//  Item.swift
//  StreamStack
//
//  Created by Ashish Karna on 21/03/2025.
//

import Foundation
import SwiftData

@Model
final class UserProfile {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
