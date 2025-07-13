//
//  Untitled.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-01.
//

import UIKit
import Firebase
import GoogleSignIn

class SignUpViewController: BaseAuthenticationViewController {
    
    @IBOutlet weak var roleSelector: UISegmentedControl!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleSignUpButton: UIButton!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    let alertManager = AlertManager()
    let firebaseManager = FirebaseManager()
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [signUpButton, googleSignUpButton]
        let textFields = [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField]
        super.viewDidLoad()
        
        roleSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "calibri", size: 12)!], for: .normal)
        
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
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        /**
         Attempts to create a new user with the entered email and password, and navigates the user to the appropriate View Controller.
         
         - Parameters:
         - sender (UIButton): Triggers the sign-up.
         */
        
        // Code from https://firebase.google.com/docs/auth/ios/password-auth
        
        // If email and password are not nil
        if let email = emailTextField.text, let password = passwordTextField.text, let confirmedPassword = confirmPasswordTextField.text {
            if password == confirmedPassword {
                
                // Create new user using email and password. createUser has email and password validation
                Auth.auth().createUser(withEmail: email, password: password) { authResult, err in
                    
                    // If there is an error, show error to user
                    if let err = err {
                        
                        // Unless the "error" is the user cancelling the authentication
                        if err.localizedDescription != "The user canceled the sign-in flow." {
                            self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                        }
                        
                    } else {
                        if let user = authResult?.user {
                            let userRole = self.roleSelector.selectedSegmentIndex == 0 ? "coach" : "athlete"
                            if userRole == "coach" {
                                self.performSegue(withIdentifier: K.signUpCoachTabSegue, sender: self)
                                self.firebaseManager.generateUniqueCoachId { coachId in
                                    self.firebaseManager.createUserDocument(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", role: userRole, coachId: coachId, email: email, uid: user.uid)
                                }
                            } else if userRole == "athlete" {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: K.signUpCodeSegue, sender: self)
                                }
                                self.firebaseManager.createUserDocument(firstName: self.firstNameTextField.text ?? "", lastName: self.lastNameTextField.text ?? "", role: userRole, coachId: "", email: email, uid: user.uid)
                            }
                        }
                    }
                }
            } else {
                self.alertManager.showAlert(alertMessage: "⚠️ Passwords do not match!", viewController: self)
            }
        }
    }
    
    
    @IBAction func googleSignUpPressed(_ sender: UIButton) {
        /**
         Initiates Google Sign-In to authenticate the user, and navigates the user to the appropriate View Controller.
         
         - Parameters:
         - sender (GIDSignInButton): Triggers Google Sign-In.
         */
        
        // Code from https://firebase.google.com/docs/auth/ios/google-signin
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start sign in flow
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
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken!,
                                                                   accessToken: user!.accessToken.tokenString)
                    
                    // Sign in user with Google
                    Auth.auth().signIn(with: credential) { result, err in
                        
                        // If there are errors in signing up, show error to user
                        if let err = err {
                            self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                            return
                        }
                        
                        guard let user = result?.user else {
                            self.alertManager.showAlert(alertMessage: "Unable to fetch Firebase user.", viewController: self)
                            return
                        }
                        
                        let splitFullName = user.displayName?.components(separatedBy: " ")
                        let firstName = splitFullName?.first ?? ""
                        let lastName = splitFullName?.count ?? 0 > 1 ? splitFullName?[1] : ""
                        
                        // Otherwise, check if user is new or not
                        
                        if let isNewUser: Bool = result?.additionalUserInfo?.isNewUser {
                            if isNewUser {
                                let userRole = self.roleSelector.selectedSegmentIndex == 0 ? "coach" : "athlete"
                                self.firebaseManager.generateUniqueCoachId { coachId in
                                    self.firebaseManager.createUserDocument(firstName: firstName, lastName: lastName!, role: userRole, coachId: coachId, email: user.email ?? "", uid: user.uid)
                                }
                                if userRole == "coach" {
                                    self.performSegue(withIdentifier: K.signUpCoachTabSegue, sender: self)
                                } else if userRole == "athlete" {
                                    self.performSegue(withIdentifier: K.signUpCodeSegue, sender: self)
                                }
                            } else {
                                self.performSegue(withIdentifier: K.signUpAthleteTabSegue, sender: self)
                            }
                        }
                    }
                }
            }
        }
    }
}
