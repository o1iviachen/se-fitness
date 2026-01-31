//
//  SceneDelegate.swift
//  se-fitness
//
//  Created by olivia chen on 2025-06-07.
//

import UIKit
import Firebase

// MARK: - SceneDelegate

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // MARK: - Properties

    var window: UIWindow?
    var handle: AuthStateDidChangeListenerHandle?

    private let firebaseManager = FirebaseManager.shared

    // MARK: - UIWindowSceneDelegate

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        self.window = window

        // Instantiate Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // One-time check for current user
        if let user = Auth.auth().currentUser {
            // User is already logged in must change
            firebaseManager.getUserData(uid: user.uid, value: "role") { [weak self] role in
                guard self != nil else { return }
                let roleString = role as? String ?? ""
                if roleString == "coach" {
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: AppConstants.coachTabBarIdentifier)
                    window.rootViewController = initialViewController
                } else {
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: AppConstants.athleteTabBarIdentifier)
                    window.rootViewController = initialViewController
                }
            }
        } else {
            // No user is logged in
            let initialViewController = storyboard.instantiateViewController(withIdentifier: AppConstants.welcomeIdentifier)
            window.rootViewController = initialViewController
        }

        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}

