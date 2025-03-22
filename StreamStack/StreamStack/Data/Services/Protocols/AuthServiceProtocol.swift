//
//  AuthServiceProtocol.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation

protocol AuthServiceProtocol {
    func signIn(email: String, password: String)  async throws -> String
    func signUp(email: String, password: String) async throws -> String
    func signOut() throws
    var currentUserId: String? { get }
}
