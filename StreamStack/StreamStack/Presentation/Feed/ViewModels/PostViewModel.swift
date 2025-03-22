//
//  PostViewModel.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation
import SwiftUI

/// A view model for managing post-related UI state and operations.
///
/// This class coordinates with a `PostUseCase` to handle post CRUD operations and sign-out,
/// exposing observable state for the UI.
@MainActor
final class PostViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published private(set) var posts: [Post] = []
    @Published var errorMessage: String?
    @Published private(set) var isLoading: Bool = false
    
    // MARK: - Dependencies
    private let postUseCase: PostUseCase
    
    // MARK: - Initialization
    /// Initializes the view model with a post use case.
    /// - Parameter postUseCase: The use case for post operations.
    init(postUseCase: PostUseCase) {
        self.postUseCase = postUseCase
    }
    
    // MARK: - Public Methods
    
    /// Loads posts from the repository.
    func loadPosts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            posts = try await postUseCase.fetchPosts()
            errorMessage = nil
        } catch {
            handleError(error, context: "loading posts")
        }
    }
    
    /// Creates a new post with the given title and content.
    /// - Parameters:
    ///   - title: The title of the post.
    ///   - content: The content of the post.
    func createPost(title: String, content: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await postUseCase.createPost(title: title, content: content)
            await loadPosts() // Refresh posts
            errorMessage = nil
        } catch {
            handleError(error, context: "creating post")
        }
    }
    
    /// Updates an existing post.
    /// - Parameters:
    ///   - id: The ID of the post to update.
    ///   - title: The new title.
    ///   - content: The new content.
    func updatePost(id: String, title: String, content: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await postUseCase.updatePost(id: id, title: title, content: content)
            await loadPosts() // Refresh posts
            errorMessage = nil
        } catch {
            handleError(error, context: "updating post")
        }
    }
    
    /// Deletes a post by its ID.
    /// - Parameter id: The ID of the post to delete.
    func deletePost(id: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await postUseCase.deletePost(id: id)
            await loadPosts() // Refresh posts
            errorMessage = nil
        } catch {
            handleError(error, context: "deleting post")
        }
    }
    
    /// Signs out the current user.
    func signOut() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await postUseCase.signOut()
            posts = [] // Clear posts on sign-out
            errorMessage = nil
        } catch {
            handleError(error, context: "signing out")
        }
    }
    
    // MARK: - Private Helpers
    
    /// Handles errors and sets appropriate error messages.
    /// - Parameters:
    ///   - error: The error encountered.
    ///   - context: The operation context for better messaging.
    private func handleError(_ error: Error, context: String) {
        switch error {
        case PostUseCaseError.invalidTitle:
            errorMessage = "Title cannot be empty."
        case PostUseCaseError.invalidContent:
            errorMessage = "Content cannot be empty."
        case PostUseCaseError.unauthenticated:
            errorMessage = "You must be signed in to \(context)."
        case PostUseCaseError.invalidPostId:
            errorMessage = "Invalid post ID."
        default:
            errorMessage = "Failed \(context): \(error.localizedDescription)"
        }
    }
}
