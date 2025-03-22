//
//  PostUseCase.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation
import FirebaseAuth

/// A use case for managing post-related business logic.
///
/// This class encapsulates operations for fetching, creating, updating, deleting posts,
/// and signing out, interacting with a `PostRepositoryProtocol`.
final class PostUseCase {
    // MARK: - Dependencies
    private let postRepository: PostRepositoryProtocol
    
    // MARK: - Initialization
    /// Initializes the use case with a post repository.
    /// - Parameter postRepository: The repository for post operations.
    init(postRepository: PostRepositoryProtocol) {
        self.postRepository = postRepository
    }
    
    // MARK: - Public Methods
    
    /// Fetches all posts for the authenticated user.
    /// - Returns: An array of `Post` objects.
    /// - Throws: Errors if fetching fails or the user is unauthenticated.
    func fetchPosts() async throws -> [Post] {
        try await postRepository.fetchPosts()
    }
    
    /// Creates a new post with the given title and content.
    /// - Parameters:
    ///   - title: The title of the post.
    ///   - content: The content of the post.
    /// - Throws: Errors if validation fails or creation fails.
    func createPost(title: String, content: String) async throws {
        try validatePostInput(title: title, content: content)
        guard let userId = Auth.auth().currentUser?.uid else {
            throw PostUseCaseError.unauthenticated
        }
        let post = Post(title: title, content: content, timestamp: Date(), userId: userId)
        try await postRepository.createPost(post)
    }
    
    /// Updates an existing post with the given ID, title, and content.
    /// - Parameters:
    ///   - id: The ID of the post to update.
    ///   - title: The new title.
    ///   - content: The new content.
    /// - Throws: Errors if validation fails or updating fails.
    func updatePost(id: String, title: String, content: String) async throws {
        try validatePostInput(title: title, content: content)
        guard let userId = Auth.auth().currentUser?.uid else {
            throw PostUseCaseError.unauthenticated
        }
        let updatedPost = Post(id: id, title: title, content: content, timestamp: Date(), userId: userId)
        try await postRepository.updatePost(updatedPost)
    }
    
    /// Deletes a post by its ID.
    /// - Parameter id: The ID of the post to delete.
    /// - Throws: Errors if deletion fails.
    func deletePost(id: String) async throws {
        guard !id.isEmpty else {
            throw PostUseCaseError.invalidPostId
        }
        try await postRepository.deletePost(id: id)
    }
    
    /// Signs out the current user.
    /// - Throws: Errors if sign-out fails.
    func signOut() async throws {
        try await postRepository.signOut()
    }
    
    // MARK: - Private Helpers
    
    /// Validates post input data.
    /// - Parameters:
    ///   - title: The title to validate.
    ///   - content: The content to validate (optional).
    /// - Throws: `PostUseCaseError` if validation fails.
    private func validatePostInput(title: String, content: String) throws {
        let titleTrimmed = title.trimmingCharacters(in: .whitespaces)
        let contentTrimmed = content.trimmingCharacters(in: .whitespaces)
        
        guard !titleTrimmed.isEmpty else {
            throw PostUseCaseError.invalidTitle
        }
        guard !contentTrimmed.isEmpty else {
            throw PostUseCaseError.invalidContent
        }
    }
}

// MARK: - Custom Errors

/// Custom error types for `PostUseCase` operations.
enum PostUseCaseError: Error {
    case unauthenticated
    case invalidPostId
    case invalidTitle
    case invalidContent
    
    var localizedDescription: String {
        switch self {
        case .unauthenticated:
            return "User must be authenticated to perform this action."
        case .invalidPostId:
            return "Post ID is invalid or missing."
        case .invalidTitle:
            return "Post title cannot be empty."
        case .invalidContent:
            return "Post content cannot be empty."
        }
    }
}
