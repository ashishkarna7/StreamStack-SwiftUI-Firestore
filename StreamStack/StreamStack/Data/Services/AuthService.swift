//
//  AuthService.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import FirebaseAuth

class AuthService: AuthServiceProtocol {
    
    var currentUserId: String? { Auth.auth().currentUser?.uid }
    
    func signIn(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user.uid
    }
    
    func signUp(email: String, password: String) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result.user.uid
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
