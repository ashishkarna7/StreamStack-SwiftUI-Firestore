//
//  UserRepositoryProtocol.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation

import Foundation

/// A protocol defining the interface for user repository operations.
///
/// Implementations handle user authentication and profile persistence.
protocol UserRepositoryProtocol {
    /// Saves a user profile to the data store.
    func saveUserProfile(_ profile: UserProfile) async throws
    
    /// Signs in a user with email and password.
    func signIn(email: String, password: String) async throws -> String
    
    /// Signs up a new user with email and password.
    func signUp(email: String, password: String) async throws -> String
    
    /// The current authenticated user's ID, if any.
    var currentUserId: String? { get }
}
