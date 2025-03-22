//
//  Post.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation
import FirebaseFirestore

struct Post: Identifiable, Codable {
    
    var id: String?
    var title: String
    var content: String
    var timestamp: Date
    let userId: String
    
    init(id: String? = nil, title: String, content: String, timestamp: Date = Date(), userId: String) {
        self.id = id
        self.title = title
        self.content = content
        self.timestamp = timestamp
        self.userId = userId
    }
}
