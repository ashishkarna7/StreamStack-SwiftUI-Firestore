//
//  AuthenticationUseCase.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation

class AuthenticationUseCase {
    private let authService: AuthServiceProtocol
    private let userRepository: UserRepositoryProtocol
    
    init(authService: AuthServiceProtocol, userRepository: UserRepositoryProtocol) {
        self.authService = authService
        self.userRepository = userRepository
    }
    
    func signIn(email: String, password: String) async throws -> UserProfile {
        let userId = try await authService.signIn(email: email, password: password)
        let profile = UserProfile(id: userId, email: email, lastLogin: Date())
        try await userRepository.saveUserProfile(profile)
        return profile
    }
    
    func signUp(email: String, password: String) async throws -> UserProfile {
        let userId = try await authService.signUp(email: email, password: password)
        let profile = UserProfile(id: userId, email: email, lastLogin: Date())
        try await userRepository.saveUserProfile(profile)
        return profile
    }
}
