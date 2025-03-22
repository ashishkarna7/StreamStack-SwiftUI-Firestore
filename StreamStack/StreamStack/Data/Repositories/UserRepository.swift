//
//  UserRepository.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

/// A concrete implementation of `UserRepositoryProtocol` using Firebase.
///
/// This class handles user authentication and profile persistence with Firestore and Firebase Auth.
final class UserRepository: UserRepositoryProtocol {
    // MARK: - Dependencies
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // MARK: - Properties
    var currentUserId: String? {
        auth.currentUser?.uid
    }
    
    // MARK: - Public Methods
    
    /// Saves a user profile to Firestore.
    /// - Parameter profile: The `UserProfile` to save.
    /// - Throws: Propagates Firestore errors if the save operation fails.
    func saveUserProfile(_ profile: UserProfile) async throws {
        guard let userId = profile.id else {
            throw UserRepositoryError.invalidUserId("User ID is nil.")
        }
        do {
            try db.collection("users").document(userId).setData(from: profile)
        } catch {
            throw UserRepositoryError.profileSaveFailed(error)
        }
    }
    
    /// Signs in a user using Firebase Auth.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The authenticated user's ID.
    /// - Throws: Propagates Firebase Auth errors.
    func signIn(email: String, password: String) async throws -> String {
        do {
            let result = try await auth.signIn(withEmail: email, password: password)
            return result.user.uid
        } catch {
            throw UserRepositoryError.signInFailed(error)
        }
    }
    
    /// Signs up a new user using Firebase Auth.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: The newly created user's ID.
    /// - Throws: Propagates Firebase Auth errors.
    func signUp(email: String, password: String) async throws -> String {
        do {
            let result = try await auth.createUser(withEmail: email, password: password)
            return result.user.uid
        } catch {
            throw UserRepositoryError.signUpFailed(error)
        }
    }
}

// MARK: - Custom Errors

/// Custom error types for `UserRepository` operations.
enum UserRepositoryError: Error {
    case invalidUserId(String)
    case signInFailed(Error)
    case signUpFailed(Error)
    case profileSaveFailed(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidUserId(let message):
            return message
        case .signInFailed(let error):
            return "Authentication failed: \(error.localizedDescription)"
        case .signUpFailed(let error):
            return "Account creation failed: \(error.localizedDescription)"
        case .profileSaveFailed(let error):
            return "Failed to save profile: \(error.localizedDescription)"
        }
    }
}

