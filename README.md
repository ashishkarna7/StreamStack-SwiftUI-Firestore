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
<img src="https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/main/StreamStack/StreamStack/Examples-Gif/login.gif" alt="Login" width="300" />

### Signup
<img src="https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/main/StreamStack/StreamStack/Examples-Gif/signup.gif" alt="Sign-Up" width="300" />

### Read/Write Post
<img src="https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/main/StreamStack/StreamStack/Examples-Gif/read-write.gif" alt="Read/Write Post" width="300" />

### Update/Delete Post
<img src="https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/main/StreamStack/StreamStack/Examples-Gif/update-delete.gif" alt="Update/Delete Post" width="300" />

### Firebase Firestore DB
<img src="https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore/blob/main/StreamStack/StreamStack/Examples-Gif/firebase-firestore.gif" alt="Firebase Firestore DB" width="300" />

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

To view the code documentation in Xcode, follow these steps:

- Open the project in **Xcode**.
- Navigate to **Product** > **Build Documentation** (or press `Shift + Command + Option + D`).
- After the build completes, open **Xcode's Documentation Browser** by going to **Window** > **Developer Documentation**.

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