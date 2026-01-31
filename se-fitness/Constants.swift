//
//  Constants.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-02.
//

import Foundation
import UIKit

// MARK: - AppConstants

enum AppConstants {
    /**
     An enum to store static Strings used throughout the app.
     */

    // MARK: - Segues

    static let signInAthleteTabSegue = "signInToAthleteTab"
    static let signUpAthleteTabSegue = "signUpToAthleteTab"
    static let signInCoachTabSegue = "signInToCoachTab"
    static let signUpCoachTabSegue = "signUpToCoachTab"
    static let codeTabSegue = "codeToAthleteTab"
    static let signInCodeSegue = "signInToCode"
    static let signUpCodeSegue = "signUpToCode"
    static let profileContactSegue = "proToContact"
    static let profileDocumentSegue = "proToDocuments"
    static let searchSegue = "searchSegue"
    static let proMainSegue = "proToMain"
    static let profileGoalSegue = "proToGoal"
    static let signInPasswordSegue = "signInToPassword"
    static let inboxToChatSegue = "inboxToChat"

    // MARK: - Cell Identifiers

    static let profileCellIdentifier = "ProfileCell"
    static let documentCellIdentifier = "DocumentCell"
    static let goalCellIdentifier = "GoalCell"
    static let workoutCellIdentifier = "WorkoutCell"
    static let exerciseCellIdentifier = "ExerciseCell"
    static let logOutCellIdentifier = "LogOutCell"
    static let textCellIdentifier = "TextCell"
    static let userCellIdentifier = "UserCell"
    static let messageCellIdentifier = "MessageCell"

    // MARK: - Storyboard Identifiers

    static let welcomeIdentifier = "NavigationController"
    static let coachTabBarIdentifier = "CoachTabBarController"
    static let athleteTabBarIdentifier = "AthleteTabBarController"
}

// MARK: - Typealias for backward compatibility

typealias K = AppConstants
