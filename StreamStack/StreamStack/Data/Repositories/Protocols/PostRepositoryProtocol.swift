//
//  PostRepositoryProtocol.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation

/// A protocol defining the interface for post-related data operations.
///
/// Implementations handle fetching, creating, updating, deleting posts, and user sign-out.
protocol PostRepositoryProtocol {
    /// Fetches all posts for the authenticated user.
    func fetchPosts() async throws -> [Post]
    
    /// Creates a new post in the data store.
    func createPost(_ post: Post) async throws
    
    /// Updates an existing post in the data store.
    func updatePost(_ post: Post) async throws
    
    /// Deletes a post by its ID.
    func deletePost(id: String) async throws
    
    /// Signs out the current user.
    func signOut() async throws
}
