//
//  SceneDelegate.swift
//  se-fitness
//
//  Created by olivia chen on 2025-06-07.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var handle: AuthStateDidChangeListenerHandle?
    let firebaseManager = FirebaseManager()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Instantiate Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // One-time check for current user
        if let user = Auth.auth().currentUser {
            // User is already logged in must change
            firebaseManager.getUserData(uid: user.uid, value: "role") { role in
                if role as! String == "coach" {
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: K.coachTabBarIdentifier)
                    window.rootViewController = initialViewController
                } else {
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: K.athleteTabBarIdentifier)
                    window.rootViewController = initialViewController
                }
            }
        } else {
            // No user is logged in
            let initialViewController = storyboard.instantiateViewController(withIdentifier: K.welcomeIdentifier)
            window.rootViewController = initialViewController
        }
        
        window.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

