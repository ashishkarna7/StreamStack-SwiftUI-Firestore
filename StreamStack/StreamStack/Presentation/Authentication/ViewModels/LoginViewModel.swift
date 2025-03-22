//
//  AuthenticationViewModel.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth // Required for AuthErrorCode

/// A view model for managing user authentication flows in the login UI.
///
/// This class coordinates with a `UserUsecase` to handle sign-in and sign-up operations,
/// providing observable state for the UI and robust error handling.
@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var errorMessage: String?
    @Published private(set) var isAuthenticated: Bool = false
    
    // MARK: - Dependencies
    private let useCase: UserUsecase
    
    // MARK: - Initialization
    init(useCase: UserUsecase) {
        self.useCase = useCase
    }
    
    // MARK: - Public Methods
    
    func signIn(email: String, password: String) async {
        do {
            try validateCredentials(email: email, password: password)
            let profile = try await useCase.signIn(email: email, password: password)
            handleSuccess(profile: profile)
        } catch {
            handleError(error, context: "Sign-in")
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            try validateCredentials(email: email, password: password)
            let profile = try await useCase.signUp(email: email, password: password)
            handleSuccess(profile: profile)
        } catch {
            handleError(error, context: "Sign-up")
        }
    }
    
    func reset() {
        isAuthenticated = false
        errorMessage = nil
    }
    
    // MARK: - Private Helpers
    
    private func validateCredentials(email: String, password: String) throws {
        let emailTrimmed = email.trimmingCharacters(in: .whitespaces)
        let passwordTrimmed = password.trimmingCharacters(in: .whitespaces)
        
        guard !emailTrimmed.isEmpty else { throw LoginError.invalidInput("Email cannot be empty.") }
        guard !passwordTrimmed.isEmpty else { throw LoginError.invalidInput("Password cannot be empty.") }
        guard isValidEmail(emailTrimmed) else { throw LoginError.invalidInput("Please enter a valid email address.") }
        guard passwordTrimmed.count >= 6 else { throw LoginError.invalidInput("Password must be at least 6 characters long.") }
    }
    
    private func handleSuccess(profile: UserProfile) {
        isAuthenticated = true
        errorMessage = nil
        print("Authenticated user: \(profile.email)")
    }
    
    private func handleError(_ error: Error, context: String) {
        switch error {
        case LoginError.invalidInput(let message):
            errorMessage = message
        case let nsError as NSError where nsError.domain == "FIRAuthErrorDomain":
            errorMessage = formatFirebaseError(nsError)
        default:
            errorMessage = "\(context) failed: \(error.localizedDescription)"
        }
        isAuthenticated = false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func formatFirebaseError(_ error: NSError) -> String {
        // Use raw values directly for older Firebase versions
        switch error.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return "Invalid email address."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Incorrect password."
        case AuthErrorCode.userNotFound.rawValue:
            return "No account exists for this email."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "This email is already in use."
        case AuthErrorCode.weakPassword.rawValue:
            return "Password is too weak. Please use a stronger password."
        case AuthErrorCode.networkError.rawValue:
            return "Network error. Please check your connection and try again."
        default:
            return "Authentication error: \(error.localizedDescription)"
        }
    }
}

// MARK: - Custom Errors
enum LoginError: Error {
    case invalidInput(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidInput(let message):
            return message
        }
    }
}

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    
    func login() {
        isAuthenticated = true
    }
    
    func logout() {
        isAuthenticated = false
    }
}
