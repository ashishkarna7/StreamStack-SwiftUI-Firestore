//
//  Item.swift
//  StreamStack
//
//  Created by Ashish Karna on 21/03/2025.
//

import Foundation

final class UserProfile: Identifiable, Codable {
    var id: String?
    var email: String
    var lastLogin: Date
    
    init(id: String? = nil, email: String, lastLogin: Date) {
        self.id = id
        self.email = email
        self.lastLogin = lastLogin
    }
}
