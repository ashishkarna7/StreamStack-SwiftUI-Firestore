//
//  AuthenticationUseCase.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation

/// A use case for managing user authentication operations.
///
/// This class encapsulates the business logic for signing in and signing up users,
/// interacting with a `UserRepositoryProtocol` to perform persistence and authentication tasks.
final class UserUsecase {
    // MARK: - Dependencies
    private let userRepository: UserRepositoryProtocol
    
    // MARK: - Initialization
    /// Initializes the use case with a user repository.
    /// - Parameter userRepository: The repository for user data operations.
    init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    // MARK: - Public Methods
    
    /// Signs in a user with the provided email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: A `UserProfile` object representing the authenticated user.
    /// - Throws: Propagates authentication or persistence errors.
    func signIn(email: String, password: String) async throws -> UserProfile {
        do {
            let userId = try await userRepository.signIn(email: email, password: password)
            let profile = UserProfile(id: userId, email: email, lastLogin: Date())
            try await saveUserProfileSafely(profile)
            return profile
        } catch {
            throw UserUsecaseError.signInFailed(error)
        }
    }
    
    /// Signs up a new user with the provided email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: A `UserProfile` object representing the newly created user.
    /// - Throws: Propagates authentication or persistence errors.
    func signUp(email: String, password: String) async throws -> UserProfile {
        do {
            let userId = try await userRepository.signUp(email: email, password: password)
            let profile = UserProfile(id: userId, email: email, lastLogin: Date())
            try await saveUserProfileSafely(profile)
            return profile
        } catch {
            throw UserUsecaseError.signUpFailed(error)
        }
    }
    
    // MARK: - Private Helpers
    
    /// Saves the user profile with error handling.
    /// - Parameter profile: The `UserProfile` to save.
    /// - Throws: Propagates persistence errors with additional context.
    private func saveUserProfileSafely(_ profile: UserProfile) async throws {
        guard profile.id != nil else {
            throw UserUsecaseError.invalidProfile("User profile ID is missing.")
        }
        do {
            try await userRepository.saveUserProfile(profile)
        } catch {
            throw UserUsecaseError.profileSaveFailed(error)
        }
    }
}

// MARK: - Custom Errors

/// Custom error types for `UserUsecase` operations.
enum UserUsecaseError: Error {
    case signInFailed(Error)
    case signUpFailed(Error)
    case invalidProfile(String)
    case profileSaveFailed(Error)
    
    var localizedDescription: String {
        switch self {
        case .signInFailed(let error):
            return "Sign-in failed: \(error.localizedDescription)"
        case .signUpFailed(let error):
            return "Sign-up failed: \(error.localizedDescription)"
        case .invalidProfile(let message):
            return message
        case .profileSaveFailed(let error):
            return "Failed to save user profile: \(error.localizedDescription)"
        }
    }
}
