//
//  StreamStackApp.swift
//  StreamStack
//
//  Created by Ashish Karna on 21/03/2025.
//

import SwiftUI
import SwiftData
import Firebase

@main
struct StreamStackApp: App {
    private let authenticationViewModel: AuthenticationViewModel
    
    init() {
        FirebaseApp.configure()
        print("Firebase configured: \(FirebaseApp.app() != nil)")
        let authService = AuthService()
        let repository = UserRepository()
        let useCase = AuthenticationUseCase(authService: authService, userRepository: repository)
        authenticationViewModel = AuthenticationViewModel(useCase: useCase)
    }

    var body: some Scene {
        WindowGroup {
            AuthenticationView(viewModel: authenticationViewModel)
        }
    }
}
