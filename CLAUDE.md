# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

This is an iOS app using CocoaPods. Open with Xcode:
```bash
open se-fitness.xcworkspace
```

Install/update dependencies:
```bash
pod install
```

Build from command line:
```bash
xcodebuild -workspace se-fitness.xcworkspace -scheme se-fitness -sdk iphonesimulator -configuration Debug build
```

## Architecture

**MVC Pattern** - Classic Model-View-Controller architecture.

### Controllers (`se-fitness/Controller/`)
- `TabBarController.swift` - Tab bar configuration for role-based navigation
- `BaseProfileViewController.swift` - Shared base class for profile screens
- `Authentication View Controllers/` - Sign-in, sign-up, password reset, coach code entry
- `Athlete View Controllers/` - Profile, workouts, messages (from coach)
- `Coach View Controllers/` - Clients list, inbox (messages from athletes)

### Models (`se-fitness/Model/`)
- **Data Models**: `User.swift`, `Workout.swift`, `Exercise.swift`, `Goal.swift`, `Document.swift`, `Message.swift`
- **Managers**: `FirebaseManager.swift` (Firestore CRUD), `AlertManager.swift`, `DateManager.swift`
- **Cell Models**: Custom UITableViewCell subclasses with corresponding XIB files

### Views (`se-fitness/View/`)
- `Main.storyboard` - Primary UI definition with all view controllers
- XIB files for custom table view cells (UserCell, ProfileCell, WorkoutCell, etc.)

### Constants (`se-fitness/Constants.swift`)
- `K` struct holds all storyboard identifiers and segue names
- Always use `K.` constants for storyboard references

## Key Patterns

**Navigation Flow**:
- `SceneDelegate.swift` sets root view controller based on auth state and user role
- Unauthenticated → `WelcomeViewController`
- Authenticated athlete → `AthleteTabBarController`
- Authenticated coach → `CoachTabBarController`

**Firebase Integration**:
- `FirebaseManager` handles all Firestore operations
- Coach codes are unique 6-character alphanumeric strings
- Athletes link to coaches via code entry in `CodeViewController`

**User Roles**: Users are either "coach" or "athlete" (stored in Firestore `role` field)

## Dependencies

- Firebase/Auth - Authentication
- Firebase/Firestore - Database
- GoogleSignIn - Google authentication
- IQKeyboardManagerSwift - Keyboard handling

## Configuration

- `GoogleService-Info.plist` - Firebase config
- `Secrets.xcconfig` - API keys (gitignored, must be created locally)
- Minimum iOS: 13.0
