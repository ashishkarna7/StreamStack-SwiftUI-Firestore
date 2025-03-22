//
//  UserRepository.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import FirebaseFirestore

class UserRepository: UserRepositoryProtocol {
    
    private let db = Firestore.firestore()
    
    func saveUserProfile(_ profile: UserProfile) async throws {
        try db.collection("users").document(profile.id!).setData(from: profile)
    }
}

