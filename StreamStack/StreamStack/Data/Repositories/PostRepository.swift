//
//  PostRepository.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

/// A concrete implementation of `PostRepositoryProtocol` using Firebase Firestore and Auth.
///
/// This class manages post persistence and user sign-out operations.
final class PostRepository: PostRepositoryProtocol {
    // MARK: - Dependencies
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // MARK: - Public Methods
    
    /// Fetches posts for the authenticated user.
    /// - Returns: An array of `Post` objects.
    /// - Throws: Errors if the user is unauthenticated or fetching fails.
    func fetchPosts() async throws -> [Post] {
        guard let userId = auth.currentUser?.uid else {
            throw PostRepositoryError.unauthenticated
        }
        
        do {
            let snapshot = try await db.collection("posts")
                .whereField("userId", isEqualTo: userId)
                .getDocuments()
            
            return snapshot.documents.compactMap { document in
                guard var post = try? document.data(as: Post.self) else { return nil }
                post.id = document.documentID
                return post
            }
        } catch {
            throw PostRepositoryError.fetchFailed(error)
        }
    }
    
    /// Creates a new post in Firestore.
    /// - Parameter post: The `Post` object to create.
    /// - Throws: Errors if the operation fails.
    func createPost(_ post: Post) async throws {
        do {
            _ = try db.collection("posts").addDocument(from: post)
        } catch {
            throw PostRepositoryError.createFailed(error)
        }
    }
    
    /// Updates an existing post in Firestore.
    /// - Parameter post: The `Post` object to update.
    /// - Throws: Errors if the post ID is nil or the update fails.
    func updatePost(_ post: Post) async throws {
        guard let id = post.id else {
            throw PostRepositoryError.invalidPostId
        }
        
        do {
            try db.collection("posts").document(id).setData(from: post)
        } catch {
            throw PostRepositoryError.updateFailed(error)
        }
    }
    
    /// Deletes a post by its ID.
    /// - Parameter id: The ID of the post to delete.
    /// - Throws: Errors if the deletion fails.
    func deletePost(id: String) async throws {
        do {
            try await db.collection("posts").document(id).delete()
        } catch {
            throw PostRepositoryError.deleteFailed(error)
        }
    }
    
    /// Signs out the current user from Firebase Auth.
    /// - Throws: Errors if sign-out fails.
    func signOut() async throws {
        do {
            try auth.signOut()
        } catch {
            throw PostRepositoryError.signOutFailed(error)
        }
    }
}

// MARK: - Custom Errors

/// Custom error types for `PostRepository` operations.
enum PostRepositoryError: Error {
    case unauthenticated
    case invalidPostId
    case fetchFailed(Error)
    case createFailed(Error)
    case updateFailed(Error)
    case deleteFailed(Error)
    case signOutFailed(Error)
    
    var localizedDescription: String {
        switch self {
        case .unauthenticated:
            return "User is not authenticated."
        case .invalidPostId:
            return "Post ID is missing or invalid."
        case .fetchFailed(let error):
            return "Failed to fetch posts: \(error.localizedDescription)"
        case .createFailed(let error):
            return "Failed to create post: \(error.localizedDescription)"
        case .updateFailed(let error):
            return "Failed to update post: \(error.localizedDescription)"
        case .deleteFailed(let error):
            return "Failed to delete post: \(error.localizedDescription)"
        case .signOutFailed(let error):
            return "Failed to sign out: \(error.localizedDescription)"
        }
    }
}
