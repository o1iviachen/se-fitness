# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Context

SE Fitness is a TrueCoach alternative built for Stephane Emard, an athletic trainer. The app connects coaches with athletes for online training services.

**Client**: Stephane Emard (athletic trainer)
**Team**: Olivia Chen and Tony Chen

## Planned Features

**Athlete features** (some implemented):
- Workouts organized by month with past/future filtering
- Workout detail view with timer and comments on exercises
- Messaging with coach
- Profile with goals, documents, personal info, developer contact, logout
- Completed workouts counter

**Coach features** (some implemented):
- Clients list with active/archived organization
- Exercise library (Stretch Affect, Central Athlete exercises)
- Messages to athletes
- Profile page

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
