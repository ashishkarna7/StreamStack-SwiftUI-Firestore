//
//  AuthenticationViewModel.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var errorMessage: String?
    @Published var isAuthenticated = false

    private let useCase: AuthenticationUseCase
    
    init(useCase: AuthenticationUseCase) {
        self.useCase = useCase
    }
    
    func signIn(email: String, password: String) async {
        do {
            _ = try await useCase.signIn(email: email, password: password)
            isAuthenticated = true
            errorMessage = nil
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            _ = try await useCase.signUp(email: email, password: password)
            isAuthenticated = true
            errorMessage = nil
        } catch {
            errorMessage = "Sign-up failed: \(error.localizedDescription)"
        }
    }
}
