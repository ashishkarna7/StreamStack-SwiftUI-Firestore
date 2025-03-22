//
//  AuthenticationView.swift
//  StreamStack
//
//  Created by Ashish Karna on 21/03/2025.
//

import SwiftUI

/// A view for handling user authentication, supporting both login and sign-up flows.
///
/// This view integrates with a `LoginViewModel` for authentication logic and an `AuthManager` for global state management.
/// It provides a responsive UI with form validation, loading states, error feedback, and success animations.
struct LoginView: View {
    // MARK: - Dependencies
    @EnvironmentObject private var authManager: AuthManager // Global authentication state manager
    @StateObject private var viewModel: LoginViewModel // Authentication logic handler
    
    // MARK: - State Properties
    @State private var email: String = "" // User's email input
    @State private var password: String = "" // User's password input
    @State private var isSignUp: Bool = false // Toggles between login and sign-up modes
    @State private var isPasswordVisible: Bool = false // Toggles password visibility
    @State private var isLoading: Bool = false // Indicates an ongoing authentication request
    @State private var showSuccessMessage: Bool = false // Shows success feedback
    
    // MARK: - Initialization
    /// Initializes the view with a configured `LoginViewModel`.
    init() {
        let useCase = UserUsecase(userRepository: UserRepository())
        _viewModel = StateObject(wrappedValue: LoginViewModel(useCase: useCase))
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Main content with scrollable form
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 100) // Centers content vertically
                    formView
                        .frame(maxWidth: 300)
                        .padding()
                }
                .frame(maxHeight: .infinity)
            }
            .scrollDismissesKeyboard(.interactively) // Dismiss keyboard on scroll
            
            // Loading overlay
            loadingOverlay
            
            // Success message overlay
            successMessageOverlay
        }
        .background(Color(.systemBackground))
        .disabled(isLoading) // Prevent interaction during loading
        .animation(.easeInOut, value: isSignUp) // Smooth mode transition
        .onChange(of: viewModel.isAuthenticated) { newValue in
            if newValue {
                authManager.login()
                withAnimation { showSuccessMessage = true }
                resetForm()
            }
        }
    }
    
    // MARK: - Subviews
    
    /// The authentication form with email, password, and action buttons.
    private var formView: some View {
        VStack(spacing: 20) {
            // Title
            Text(isSignUp ? "Sign Up" : "Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Email Field
            TextField("Email", text: $email)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress) // Improves autofill
                .submitLabel(.next) // Keyboard navigation
            
            // Password Field with Visibility Toggle
            passwordField
            
            // Error Message
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .transition(.opacity)
            }
            
            // Submit Button
            Button(action: { Task { await submitAction() } }) {
                Text(isSignUp ? "Sign Up" : "Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isFormValid ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!isFormValid || isLoading)
            
            // Toggle Mode Button
            Button(action: toggleMode) {
                Text(isSignUp ? "Already have an account? Login" : "Need an account? Sign Up")
                    .font(.subheadline)
                    .foregroundStyle(.blue)
            }
            .disabled(isLoading)
        }
    }
    
    /// Password input field with visibility toggle.
    private var passwordField: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
                }
            }
            .textFieldStyle(PlainTextFieldStyle())
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
            .textContentType(.password) // Improves autofill
            .submitLabel(.done) // Keyboard navigation
            
            Button(action: { isPasswordVisible.toggle() }) {
                Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                    .foregroundStyle(.gray)
                    .padding(.trailing, 8)
            }
        }
    }
    
    /// Overlay shown during authentication requests.
    private var loadingOverlay: some View {
        Group {
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
    }
    
    /// Overlay for success feedback with auto-dismissal.
    private var successMessageOverlay: some View {
        Group {
            if showSuccessMessage {
                Text(isSignUp ? "Sign Up Successful!" : "Login Successful!")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 20)
                    .task { await dismissSuccessMessage() }
            }
        }
        .animation(.easeInOut, value: showSuccessMessage)
    }
    
    // MARK: - Computed Properties
    
    /// Determines if the form is valid for submission.
    private var isFormValid: Bool {
        let emailTrimmed = email.trimmingCharacters(in: .whitespaces)
        let passwordTrimmed = password.trimmingCharacters(in: .whitespaces)
        return !emailTrimmed.isEmpty && isValidEmail(emailTrimmed) && passwordTrimmed.count >= 6
    }
    
    // MARK: - Actions
    
    /// Submits the login or sign-up request based on the current mode.
    private func submitAction() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false } // Ensure loading state resets
        
        if isSignUp {
            await viewModel.signUp(email: email, password: password)
        } else {
            await viewModel.signIn(email: email, password: password)
        }
    }
    
    /// Toggles between login and sign-up modes.
    private func toggleMode() {
        isSignUp.toggle()
        viewModel.errorMessage = nil
        resetForm()
    }
    
    /// Resets the form fields to their initial state.
    private func resetForm() {
        email = ""
        password = ""
        isPasswordVisible = false
    }
    
    /// Dismisses the success message after a delay.
    private func dismissSuccessMessage() async {
        do {
            try await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            withAnimation { showSuccessMessage = false }
        } catch {
            // Task cancellation is safe to ignore
            showSuccessMessage = false
        }
    }
    
    // MARK: - Helpers
    
    /// Validates email format using a basic regex.
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

// MARK: - Preview
#Preview {
    LoginView()
        .environmentObject(AuthManager()) // Mock AuthManager for preview
}
