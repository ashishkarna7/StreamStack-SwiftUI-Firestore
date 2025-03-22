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
   ```bash
   git clone https://github.com/ashishkarna7/StreamStack-SwiftUI-Firestore.git
   cd StreamStack-SwiftUI-Firestore
   ```

2. **Open in Xcode**  
   - Open the project file:  
     ```bash
     open StreamStack-SwiftUI-Firestore.xcodeproj
     ```

3. **Add Firebase via Swift Package Manager**  
   - In Xcode, go to `File > Add Packages`  
   - Enter the Firebase SPM URL: `https://github.com/firebase/firebase-ios-sdk`  
   - Select version `10.0.0` or later  
   - Add the package and include the following dependencies:  
     - `FirebaseAuth`  
     - `FirebaseFirestore`  
   - Click "Add Package" to resolve and download dependencies  

4. **Configure Firebase**  
   - Go to the [Firebase Console](https://console.firebase.google.com/), create a new project, and add an iOS app  
   - Download the `GoogleService-Info.plist` file and drag it into the root of your Xcode project (ensure it’s added to the target)  
   - Enable **Authentication** (Email/Password) and **Firestore** in the Firebase Console  

5. **Initialize Firebase**  
   - Ensure Firebase is initialized in your app entry point:  
     ```swift
     import FirebaseCore

     @main
     struct StreamStackApp: App {
         init() {
             FirebaseApp.configure()
         }
         
         var body: some Scene {
             WindowGroup {
                 LoginView()
                     .environmentObject(AuthManager())
             }
         }
     }
     ```

6. **Build and Run**  
   - Select an iOS simulator (16.6+) or physical device  
   - Press `Cmd + R` in Xcode to build and run the app  

---

## Documentation

### Project Structure
- **Clean Architecture**:  
  - **Presentation Layer**: SwiftUI views (`LoginView`, `PostView`) and view models (`LoginViewModel`, `PostViewModel`)  
  - **Domain Layer**: Use cases (`UserUsecase`, `PostUseCase`) encapsulating business logic  
  - **Data Layer**: Repositories (`UserRepository`, `PostRepository`) interfacing with Firebase  
- **SOLID Principles**:  
  - **Single Responsibility**: Each class has a single purpose (e.g., `PostUseCase` manages post logic)  
  - **Open/Closed**: Protocols (`UserRepositoryProtocol`, `PostRepositoryProtocol`) allow extension without modification  
  - **Liskov Substitution**: Repository implementations can be swapped without affecting use cases  
  - **Interface Segregation**: Separate protocols for auth and post operations  
  - **Dependency Inversion**: High-level modules depend on abstractions, not concrete implementations  

### Key Components
- **`AuthManager`**: Manages global authentication state with `isAuthenticated: Bool`, `login()`, and `logout()`  
- **`UserProfile`**: Model for user data (`id: String?`, `email: String`, `lastLogin: Date`)  
- **`Post`**: Model for post data (`id: String?`, `title: String`, `content: String`, `timestamp: Date`, `userId: String`)  

---

## Technical Details

- **Language**: Swift 5.7+  
- **Framework**: SwiftUI  
- **Backend**: Firebase  
  - **Firebase/Auth**: For email/password authentication  
  - **Firebase/Firestore**: For post storage and retrieval  
- **Minimum iOS Version**: 16.6  
- **Dependencies**: Managed via SPM:  
  - `firebase-ios-sdk` (~> 10.0.0): Includes `FirebaseAuth` and `FirebaseFirestore`  
- **Architecture**: Clean Architecture with MVVM  
- **Concurrency**: Swift Concurrency (`async/await`) for network operations  

---

## Troubleshooting

- **"Firebase not configured" Error**:  
  - Verify `GoogleService-Info.plist` is in the project root and `FirebaseApp.configure()` is called in the app’s entry point  
- **"Package Resolution Failed"**:  
  - Ensure an internet connection and retry `File > Add Packages` in Xcode. Check SPM cache (`Product > Clean Build Folder`)  
- **Authentication Fails**:  
  - Confirm Email/Password auth is enabled in Firebase Console  
  - Test with valid credentials and check network status  
- **Posts Not Loading**:  
  - Ensure Firestore security rules allow authenticated access:  
    ```plaintext
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
        match /{document=**} {
          allow read, write: if request.auth != null;
        }
      }
    }
    ```
- **Build Errors**:  
  - Set iOS deployment target to 16.6 (`Project Settings > General`)  
  - Ensure Firebase SPM dependencies are correctly linked  

---

## Technical Challenges & Solutions

1. **Challenge**: Graceful Firebase Error Handling  
   - **Solution**: Created custom error enums (`LoginError`, `PostUseCaseError`) and mapped Firebase `AuthErrorCode` values to user-friendly messages  

2. **Challenge**: Real-Time Data Updates  
   - **Solution**: Implemented manual refresh after CRUD operations; future iterations could use Firestore listeners for real-time updates  

3. **Challenge**: Preventing Race Conditions  
   - **Solution**: Used `isLoading` state with `defer` in view models to disable UI during async operations  

4. **Challenge**: Ensuring Modular Design  
   - **Solution**: Separated concerns into presentation, domain, and data layers, using protocols for dependency injection  

---

## Assumptions & Design Decisions

- **Assumptions**:  
  - Firebase Auth manages unique email-based user accounts  
  - Posts are scoped to authenticated users via `userId`  
  - Firestore rules restrict access to authenticated users only  
- **Design Decisions**:  
  - **SwiftUI**: Chosen for its declarative syntax and iOS 16.6+ compatibility  
  - **SPM**: Preferred over CocoaPods for simpler dependency management within Xcode  
  - **Manual Refresh**: Opted for simplicity over real-time Firestore listeners; can be extended later  
  - **Error Handling**: Centralized in view models with detailed feedback for users  
  - **Dependency Injection**: Protocols ensure testability and flexibility  
