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
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            
            // Instantiate Storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // Determine if there if a user logged in; code from https://stackoverflow.com/questions/37873608/how-do-i-detect-if-a-user-is-already-logged-in-firebase
            handle = Auth.auth().addStateDidChangeListener { auth, user in
                var initialViewController: UIViewController?
                // If a user is logged in, go to tab bar view controller
                if let user = user {
                    self.firebaseManager.getUserData(uid: user.uid, value: "role") { role in
                        if role == "coach" {
                            // initialViewController = storyboard.instantiateViewController(withIdentifier: K.coachTabBarIdentifier)
                            initialViewController = storyboard.instantiateViewController(withIdentifier: K.athleteTabBarIdentifier)
                            window.rootViewController = initialViewController!
                        } else if role == "athlete" {
                            initialViewController = storyboard.instantiateViewController(withIdentifier: K.athleteTabBarIdentifier)
                            window.rootViewController = initialViewController!
                        } else {
                            initialViewController = storyboard.instantiateViewController(withIdentifier: K.welcomeIdentifier)
                            window.rootViewController = initialViewController!
                        }
                    }
                }
                
                // If no user is logged in, go to welcome view controller
                else {
                    initialViewController = storyboard.instantiateViewController(withIdentifier: K.welcomeIdentifier)
                    window.rootViewController = initialViewController!
                }
            }
            
            
            window.makeKeyAndVisible()
            guard let _ = (scene as? UIWindowScene) else { return }
        }
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

