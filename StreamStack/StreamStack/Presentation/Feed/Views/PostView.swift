//
//  PostView.swift
//  StreamStack
//
//  Created by Ashish Karna on 22/03/2025.
//

import SwiftUI

/// A view for displaying and managing user posts, supporting creation, editing, and deletion.
///
/// This view integrates with a `PostViewModel` for post operations and an `AuthManager` for authentication state,
/// offering a polished UI with loading states, form validation, error alerts, and confirmation dialogs.
struct PostView: View {
    // MARK: - Dependencies
    @EnvironmentObject private var authManager: AuthManager
    @StateObject private var viewModel: PostViewModel
    
    // MARK: - State
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var editingPost: Post?
    @State private var isShowingConfirmationDialog: Bool = false
    @State private var postToDelete: Post?
    
    // MARK: - Initialization
    init() {
        let repository = PostRepository()
        let useCase = PostUseCase(postRepository: repository)
        _viewModel = StateObject(wrappedValue: PostViewModel(postUseCase: useCase))
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                postListView
                if authManager.isAuthenticated && !viewModel.isLoading {
                    postFormView
                }
            }
            .navigationTitle("Posts")
            .toolbar { toolbarContent }
            .task { await viewModel.loadPosts() }
            .alert(
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )
            ) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage ?? "An unexpected error occurred."),
                    dismissButton: .default(Text("OK"))
                )
            }
            .confirmationDialog(
                "Are you sure you want to delete this post?",
                isPresented: $isShowingConfirmationDialog,
                titleVisibility: .visible
            ) {
                Button("Delete", role: .destructive) { Task { await deletePost() } }
                Button("Cancel", role: .cancel) { postToDelete = nil }
            }
            .disabled(!authManager.isAuthenticated || viewModel.isLoading)
            .animation(.easeInOut, value: authManager.isAuthenticated)
            .background(Color(.systemBackground))
        }
    }
    
    // MARK: - Subviews
    
    private var postListView: some View {
        Group {
            if !authManager.isAuthenticated {
                Text("Please sign in to view posts.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.isLoading && viewModel.posts.isEmpty {
                ProgressView("Loading posts...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.posts.isEmpty {
                Text("No posts available.")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(viewModel.posts) { post in
                    PostRowView(
                        post: post,
                        onEdit: { prepareForEditing(post: post) },
                        onDelete: { postToDelete = post; isShowingConfirmationDialog = true }
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color(.systemBackground))
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
        }
    }
    
    private var postFormView: some View {
        VStack(spacing: 10) {
            TextField("Title", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.next)
                .textContentType(.name)
            
            TextField("Content", text: $content)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .submitLabel(.done)
            
            Button(action: { Task { await submitPost() } }) {
                Text(editingPost == nil ? "Create Post" : "Update Post")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isFormValid)
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(radius: 2)
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button("Sign Out") {
                Task { await viewModel.signOut(); authManager.logout() }
            }
            .disabled(viewModel.isLoading || !authManager.isAuthenticated)
        }
    }
    
    // MARK: - Computed Properties
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty &&
        !content.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    // MARK: - Actions
    
    private func prepareForEditing(post: Post) {
        title = post.title
        content = post.content
        editingPost = post
    }
    
    private func submitPost() async {
        if let editingPost = editingPost, let postId = editingPost.id {
            await viewModel.updatePost(id: postId, title: title, content: content)
        } else {
            await viewModel.createPost(title: title, content: content)
        }
        resetForm()
    }
    
    private func deletePost() async {
        if let postId = postToDelete?.id {
            await viewModel.deletePost(id: postId)
            if editingPost?.id == postId { resetForm() }
        }
        postToDelete = nil
    }
    
    private func resetForm() {
        title = ""
        content = ""
        editingPost = nil
    }
}

// MARK: - Post Row View

/// A reusable view for displaying a single post with edit and delete actions.
struct PostRowView: View {
    let post: Post
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
            Text(post.content)
                .font(.body)
                .lineLimit(2)
            Text(post.timestamp, style: .date)
                .font(.caption)
                .foregroundStyle(.gray)
            HStack {
                Button("Edit", action: onEdit)
                Button("Delete", action: onDelete)
                    .foregroundColor(.red)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    PostView()
        .environmentObject(AuthManager())
}
