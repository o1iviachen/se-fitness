//
//  WelcomeViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-01.
//

import UIKit
import Firebase
import GoogleSignIn

class WelcomeViewController: BaseAuthenticationViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: UIButton!
    let alertManager = AlertManager()
    let firebaseManager = FirebaseManager()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [signInButton, googleSignInButton, newButton]
        let textFields = [emailTextField, passwordTextField]
        super.viewDidLoad()
        
        forgotButton.titleLabel?.font = UIFont(name: "calibri-bold", size: 12)
        
        for button in buttons {
            if let safeButton = button {
                safeButton.titleLabel?.font = UIFont(name: "calibri", size: 13)
                safeButton.layer.cornerRadius = 12
            }
        }
        
        for textField in textFields {
            textField?.font = UIFont(name: "calibri", size: 15)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /**
         Passes the user's email address before the user navigates to the password screen.
         
         - Parameters:
         - segue (UIStoryboardSegue): Indicates the View Controllers involved in the segue.
         - sender (Optional Any): Indicates the object that initiated the segue.
         */
        
        // If segue that will be performed goes to password view controller
        if segue.identifier == K.signInPasswordSegue {
            
            // Force downcast destinationVC as PasswordViewController
            let destinationVC = segue.destination as! PasswordViewController
            
            // Set PasswordViewController class attribute as user's email, if typed
            if let email = emailTextField.text {
                destinationVC.email = email
            }
        }
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        /**
         Allows the user to log-in using their email and password, and performs the appropriate segue if the attempt is successful.
         
         - Parameters:
         - sender (UIButton): Triggers the log-in.
         */
        
        // Code from https://firebase.google.com/docs/auth/ios/password-auth
        
        // If email and password are not nil
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            // Sign in user using email and password. signIn has email and password validation
            Auth.auth().signIn(withEmail: email, password: password) { authResult, err in
                
                // If there is an error, show error to user
                if let err = err {
                    
                    // Unless the "error" is the user cancelling the authentication
                    if err.localizedDescription != "The user canceled the sign-in flow." {
                        self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                    }
                    
                    // Otherwise, perform segue to tab bar view controller
                } else {
                    if let user = authResult?.user {
                        self.firebaseManager.getUserData(uid: user.uid, value: "role") { role in
                            if role == "coach" {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: K.signInCoachTabSegue, sender: self)
                                }
                            } else if role == "athlete" {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: K.signInAthleteTabSegue, sender: self)
                                }
                            } else {
                                self.alertManager.showAlert(alertMessage: role!, viewController: self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func googleLogInPressed(_ sender: UIButton) {
        /**
         Allows the user to log-in using Google Sign-In, and performs the appropriate segue if the attempt is successful.
         
         - Parameters:
         - sender (GIDSignInButton): Triggers Google Sign-In.
         */
        
        // Code from https://firebase.google.com/docs/auth/ios/google-signin
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, err in
            
            // If there is an error, show error to user
            if let err = err {
                
                // Unless the "error" is the user cancelling the authentication
                if err.localizedDescription != "The user canceled the sign-in flow." {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                }
            } else {
                if (result?.user) != nil {
                    let user = result?.user
                    let idToken = user?.idToken?.tokenString
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken!, accessToken: user!.accessToken.tokenString)
                    
                    // Sign in user with Google
                    Auth.auth().signIn(with: credential) { authResult, err in
                        
                        // If there are errors in signing in, show error to user
                        if let err = err {
                            self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                            return
                        }
                        
                        guard let user = authResult?.user else {
                            self.alertManager.showAlert(alertMessage: "Unable to fetch Firebase user.", viewController: self)
                            return
                        }
                        // Otherwise, check if user is new or not
                        
                        if let isNewUser: Bool = authResult?.additionalUserInfo?.isNewUser {
                            
                            // If user is new, go to calculator view controller
                            if isNewUser {
                                
                                var selectedRole: String?
                                
                                let alert = UIAlertController(title: "Welcome!", message: "We see that you're new. Are you a coach or an athlete?", preferredStyle: .alert)
                                
                                let options = ["Coach", "Athlete"]
                                
                                for option in options {
                                    alert.addAction(UIAlertAction(title: option, style: .default) { action in
                                        selectedRole = action.title!.lowercased()
                                    })
                                }
                                // Present the alert
                                self.present(alert, animated: true, completion: nil)
                                
                                let splitFullName = user.displayName?.components(separatedBy: " ")
                                let firstName = splitFullName?.first ?? ""
                                let lastName = (splitFullName?.count ?? 0) > 1 ? (splitFullName?[1] ?? "") : ""
                                
                                self.firebaseManager.generateUniqueCoachId { coachId in
                                    self.firebaseManager.createUserDocument(firstName: firstName, lastName: lastName, role: selectedRole!, coachId: coachId, email: user.email ?? "", uid: user.uid)
                                }
                                
                                // clunky
                                if selectedRole == "Coach" {
                                    self.performSegue(withIdentifier: K.signInCoachTabSegue, sender: self)
                                    
                                } else if selectedRole == "Athlete" {
                                    self.performSegue(withIdentifier: K.signInCodeSegue, sender: self)
                                    
                                }
                                
                            } else {
                                self.firebaseManager.getUserData(uid: user.uid, value: "role") { role in
                                    if role == "coach" {
                                        self.performSegue(withIdentifier: K.signInCoachTabSegue, sender: self)
                                        
                                    } else if role == "athlete" {
                                        self.performSegue(withIdentifier: K.signInAthleteTabSegue, sender: self)
                                        
                                    } else {
                                        self.alertManager.showAlert(alertMessage: role!, viewController: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
