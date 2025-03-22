//
//  UserRepositoryProtocol.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation

protocol UserRepositoryProtocol {
    func saveUserProfile(_ profile: UserProfile) async throws
}
