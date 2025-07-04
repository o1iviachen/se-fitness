//
//  Untitled.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-01.
//

import UIKit
import Firebase
import GoogleSignIn

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var roleSelector: UISegmentedControl!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleSignUpButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    let height = UIScreen.main.bounds.height
    let alertManager = AlertManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttons = [signUpButton, googleSignUpButton]
        let textFields = [emailTextField, passwordTextField, confirmPasswordTextField]
        super.viewDidLoad()
        
        // Adjust SE Fitness logo positioning based on screen size
        logoHeightConstraint.constant = height * 0.15
        logoWidthConstraint.constant = CGRectGetHeight(self.logoView.bounds) * 2
        logoTopConstraint.constant = height * 0.10
        view.layoutIfNeeded()
        
        roleSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "calibri", size: 12)!], for: .normal)

        for button in buttons {
            if let safeButton = button {
                safeButton.titleLabel?.font = UIFont(name: "calibri", size: 15)
                safeButton.layer.cornerRadius = 12
            }
        }
        
        for textField in textFields {
            textField?.font = UIFont(name: "calibri", size: 15)
        }
        
        // Keyboard goes down when screen is tapped outside and swipped
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc func dismissKeyboard() {
        /**
         Dimisses the keyboard.
         */
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
                        
                        // Otherwise, perform segue to calculator
                    } else {
                        self.performSegue(withIdentifier: K.signUpCalculatorSegue, sender: self)
                    }
                }
            } else {
                self.alertManager.showAlert(alertMessage: "⚠️ Passwords do not match! ", viewController: self)
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
                            
                        }
                        
                        // Otherwise, check if user is new or not
                        else {
                            
                            if let isNewUser: Bool = result?.additionalUserInfo?.isNewUser {
                                
                                // If user is new, go to calculator view controller
                                if isNewUser {
                                    self.performSegue(withIdentifier: K.signUpCalculatorSegue, sender: self)
                                }
                                
                                // If user is not new, go to tab bar view controller
                                else {
                                    self.performSegue(withIdentifier: K.signUpTabSegue, sender: self)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
