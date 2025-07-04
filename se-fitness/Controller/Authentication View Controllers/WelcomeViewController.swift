//
//  WelcomeViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-01.
//

import UIKit
import Firebase
import GoogleSignIn

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    
    @IBOutlet weak var googleSignInButton: UIButton!
    let height = UIScreen.main.bounds.height
    let alertManager = AlertManager()
    
    override func viewDidLoad() {
        let buttons = [signInButton, googleSignInButton, newButton]
        let textFields = [emailTextField, passwordTextField]
        super.viewDidLoad()
        
        // Adjust SE Fitness logo positioning based on screen size
        logoHeightConstraint.constant = height * 0.15
        logoWidthConstraint.constant = CGRectGetHeight(self.logoView.bounds) * 2
        logoTopConstraint.constant = height * 0.10
        view.layoutIfNeeded()
        
        forgotButton.titleLabel?.font = UIFont(name: "calibri-bold", size: 12)
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            /**
             Passes the user's email address before the user navigates to the password screen.
             
             - Parameters:
                - segue (UIStoryboardSegue): Indicates the View Controllers involved in the segue.
                - sender (Optional Any): Indicates the object that initiated the segue.
             */
                    
            // If segue that will be performed goes to password view controller
            if segue.identifier == K.logInPasswordSegue {
                
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
                    self.performSegue(withIdentifier: K.logInTabSegue, sender: self)
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
                        Auth.auth().signIn(with: credential) { result, err in
                            
                            // If there are errors in signing in, show error to user
                            if let err = err {
                                self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                            }
                            
                            // Otherwise, check if user is new or not
                            else {
                                
                                if let isNewUser: Bool = result?.additionalUserInfo?.isNewUser {
                                    
                                    // If user is new, go to calculator view controller
                                    if isNewUser {
                                        self.performSegue(withIdentifier: K.logInCalculatorSegue, sender: self)
                                    }
                                    
                                    // If user is not new, go to tab bar view controller
                                    else {
                                        self.performSegue(withIdentifier: K.logInTabSegue, sender: self)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
