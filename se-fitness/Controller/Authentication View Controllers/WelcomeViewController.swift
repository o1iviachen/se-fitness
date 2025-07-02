//
//  WelcomeViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-01.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotButton: UIButton!
    
    let height = UIScreen.main.bounds.height
    let alertManager = AlertManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adjust SE Fitness logo positioning based on screen size
        view.translatesAutoresizingMaskIntoConstraints = false
        logoHeightConstraint.constant = height * 0.15
        logoWidthConstraint.constant = CGRectGetHeight(self.logoView.bounds) * 2
        logoTopConstraint.constant = height * 0.10
        view.layoutIfNeeded()
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
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
}
