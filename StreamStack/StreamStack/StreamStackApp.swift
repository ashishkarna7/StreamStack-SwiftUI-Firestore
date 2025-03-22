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
    @StateObject private var authManager: AuthManager
    
    init() {
        FirebaseApp.configure()
        _authManager = StateObject(wrappedValue: AuthManager())
    }

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                PostView().environmentObject(authManager)
            } else {
                LoginView().environmentObject(authManager)
            }
        }
    }
}
