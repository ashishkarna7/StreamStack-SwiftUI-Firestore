//
//  AuthenticationView.swift
//  StreamStack
//
//  Created by Ashish Karna on 21/03/2025.
//

import SwiftUI

struct AuthenticationView: View {
    @StateObject var viewModel: AuthenticationViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var isPasswordVisible = false
    @State private var isLoading = false
    @State private var showSuccessMessage = false
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer() // Push content down to center
                    .padding(100)
                
                VStack(spacing: 20) {
                    Text(isSignUp ? "Sign Up" : "Login")
                        .font(.largeTitle)
                        .bold()
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6)) // Light gray fill
                        )
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    ZStack(alignment: .trailing) {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6)) // Light gray fill
                                )
                        } else {
                            SecureField("Password", text: $password)
                                .textFieldStyle(PlainTextFieldStyle())
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6)) // Light gray fill
                                )
                        }
                        
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundStyle(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(Color.red)
                            .font(.caption)
                    }
                    
                    Button(action: {
                        Task {
                            isLoading = true
                            if isSignUp {
                                await viewModel.signUp(email: email, password: password)
                            } else {
                                await viewModel.signIn(email: email, password: password)
                            }
                            if viewModel.isAuthenticated {
                                showSuccessMessage = true
                            }
                            isLoading = false
                        }
                    }) {
                        Text(isSignUp ? "Sign Up" : "Login")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(Color.white)
                            .cornerRadius(8)
                    }
                    .disabled(isLoading)
                    
                    Button(action: {
                        isSignUp.toggle()
                        viewModel.errorMessage = nil
                    }) {
                        Text(isSignUp ? "Already have an account? Login" : "Need an account? Sign Up")
                    }
                }
                .padding()
                .frame(maxWidth: 300)
            }
            
            if isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
        .overlay(alignment: .bottom) {
            if showSuccessMessage {
                Text(isSignUp ? "Sign Up Successful!" : "Login Successful!")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .transition(.move(edge: .bottom))
                    .task {
                        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 seconds
                        withAnimation {
                            showSuccessMessage = false
                        }
                    }
            }
        }
    }
}


#Preview {
    let authService = AuthService()
    let userRepository = UserRepository()
    let useCase = AuthenticationUseCase(authService: authService,
                                        userRepository: userRepository)
    let viewModel = AuthenticationViewModel(useCase: useCase)
    return AuthenticationView(viewModel: viewModel)
}
