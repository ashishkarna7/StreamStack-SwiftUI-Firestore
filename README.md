# StreamStack-SwiftUI-Firestore

A modern iOS application built with SwiftUI and Firebase, featuring user authentication (login/signup) and a post management module (create, edit, delete, fetch). This project leverages Firebase Authentication and Firestore, following clean architecture principles and adhering to SOLID design patterns for maintainability and scalability.

**GitHub Repository:** [https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore](https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore)  
**Minimum iOS Version:** 16.6

---

## Features

- **Authentication Module**:  
  - Login and sign-up with email/password using Firebase Auth  
  - Client-side form validation, loading states, and success/error feedback  
- **Post Module**:  
  - Create, edit, delete, and fetch posts stored in Firestore  
  - Authenticated access only, with real-time data refresh  

---

## Demo

### Login
![Login](https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/Ashish/Feature/Firestore/StreamStack/StreamStack/Examples-Gif/login.gif)

### Signup
![Sign-Up](https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/Ashish/Feature/Firestore/StreamStack/StreamStack/Examples-Gif/signup.gif)

### Read/Write Post
![Read/Write Post](https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/Ashish/Feature/Firestore/StreamStack/StreamStack/Examples-Gif/read-write.gif)

### Update/Delete Post
![Update/Delete Post](https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/Ashish/Feature/Firestore/StreamStack/StreamStack/Examples-Gif/update-delete.gif)

### Firebase Firestore DB
![Firebase Firestore DB](https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/Ashish/Feature/Firestore/StreamStack/StreamStack/Examples-Gif/firebase-firestore.gif)

---

## Prerequisites

Before setting up the project, ensure you have the following:

- **Xcode**: Version 14.0 or later (compatible with iOS 16.6)  
- **Swift**: 5.7 or later  
- **Firebase Account**: Required for Firebase Authentication and Firestore integration  
- **Swift Package Manager (SPM)**: Built into Xcode; no additional installation needed  
- **Git**: For cloning the repository  
- **Apple Developer Account**: Optional, for testing on physical devices  

---

## Installation Steps

1. **Clone the Repository**  
   Clone the project from GitHub and navigate into the directory.

2. **Open in Xcode**  
   Open the `.xcodeproj` file in Xcode.

3. **Add Firebase via Swift Package Manager**  
   - In Xcode, go to `File > Add Packages`  
   - Use the Firebase SPM URL and select version 10.0.0 or later  
   - Include `FirebaseAuth` and `FirebaseFirestore` dependencies  

4. **Configure Firebase**  
   - Create a new project in the Firebase Console and add an iOS app  
   - Download `GoogleService-Info.plist` and add it to the project root  
   - Enable Email/Password Authentication and Firestore  

5. **Initialize Firebase**  
   Ensure Firebase is set up in the app’s entry point.

6. **Build and Run**  
   Select an iOS simulator (16.6+) or device and run the app in Xcode.

---

## Documentation

### Project Structure

- **Clean Architecture**:  
  - **Presentation Layer**: SwiftUI views and view models  
  - **Domain Layer**: Use cases for business logic  
  - **Data Layer**: Repositories interfacing with Firebase  
- **SOLID Principles**:  
  - **Single Responsibility**: Each class has one purpose  
  - **Open/Closed**: Protocols allow extension without modification  
  - **Liskov Substitution**: Swappable repository implementations  
  - **Interface Segregation**: Separate protocols for different operations  
  - **Dependency Inversion**: Abstractions over concrete implementations  

### Key Components

- **AuthManager**: Manages authentication state (login/logout)  
- **UserProfile**: Model for user data (ID, email, last login)  
- **Post**: Model for post data (ID, title, content, timestamp, user ID)  

---

## Technical Details

- **Language**: Swift 5.7+  
- **Framework**: SwiftUI  
- **Backend**: Firebase (Authentication and Firestore)  
- **Minimum iOS Version**: 16.6  
- **Dependencies**: Firebase SDK via SPM (version 10.0.0+)  
- **Architecture**: Clean Architecture with MVVM  
- **Concurrency**: Swift Concurrency for network operations  

---

## Troubleshooting

- **Firebase Not Configured**: Ensure the `.plist` file is added and Firebase is initialized  
- **Package Issues**: Check internet connection and clean Xcode build folder  
- **Authentication Fails**: Verify Email/Password is enabled in Firebase  
- **Posts Not Loading**: Check Firestore security rules for authenticated access  
- **Build Errors**: Confirm iOS target is 16.6 and dependencies are linked  

---

## Technical Challenges & Solutions

1. **Challenge**: Firebase Error Handling  
   - **Solution**: Custom error messages for user feedback  
2. **Challenge**: Real-Time Updates  
   - **Solution**: Manual refresh; listeners possible in future  
3. **Challenge**: Race Conditions  
   - **Solution**: Loading states to disable UI during operations  
4. **Challenge**: Modular Design  
   - **Solution**: Layered architecture with dependency injection  

---

## Assumptions & Design Decisions

- **Assumptions**:  
  - Unique email-based user accounts in Firebase Auth  
  - Posts tied to users via `userId`  
  - Authenticated access only in Firestore  
- **Design Decisions**:  
  - SwiftUI for modern iOS development  
  - SPM for dependency management  
  - Manual refresh for simplicity  
  - Centralized error handling in view models  
  - Protocols for testability and flexibility  