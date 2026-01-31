//
//  WelcomeViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-01.
//

import UIKit
import Firebase
import GoogleSignIn

// MARK: - WelcomeViewController

final class WelcomeViewController: BaseAuthenticationViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var forgotButton: UIButton!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var newButton: UIButton!
    @IBOutlet private weak var googleSignInButton: UIButton!

    // MARK: - Properties

    private let alertManager = AlertManager.shared
    private let firebaseManager = FirebaseManager.shared
    private let db = Firestore.firestore()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.signInPasswordSegue {
            guard let destinationVC = segue.destination as? PasswordViewController else { return }
            if let email = emailTextField.text {
                destinationVC.email = email
            }
        }
    }

    // MARK: - Private Methods

    private func setupUI() {
        let buttons = [signInButton, googleSignInButton, newButton]
        let textFields = [emailTextField, passwordTextField]

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

    // MARK: - IBActions
    
    @IBAction private func signInPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, err in
            guard let self = self else { return }

            if let err = err {
                if err.localizedDescription != "The user canceled the sign-in flow." {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                }
                return
            }

            guard let user = authResult?.user else { return }

            self.firebaseManager.getUserData(uid: user.uid, value: "role") { [weak self] role in
                guard let self = self else { return }
                let castedRole = role as? String ?? ""
                if castedRole == "coach" {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: AppConstants.signInCoachTabSegue, sender: self)
                    }
                } else if castedRole == "athlete" {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: AppConstants.signInAthleteTabSegue, sender: self)
                    }
                } else {
                    self.alertManager.showAlert(alertMessage: castedRole, viewController: self)
                }
            }
        }
    }
    
    @IBAction private func googleLogInPressed(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, err in
            guard let self = self else { return }

            if let err = err {
                if err.localizedDescription != "The user canceled the sign-in flow." {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                }
                return
            }

            guard let googleUser = result?.user,
                  let idToken = googleUser.idToken?.tokenString else { return }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: googleUser.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [weak self] authResult, err in
                guard let self = self else { return }

                if let err = err {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                    return
                }

                guard let user = authResult?.user else {
                    self.alertManager.showAlert(alertMessage: "Unable to fetch Firebase user.", viewController: self)
                    return
                }

                guard let isNewUser = authResult?.additionalUserInfo?.isNewUser else { return }

                if isNewUser {
                    self.showRoleSelectionAlert(for: user)
                } else {
                    self.firebaseManager.getUserData(uid: user.uid, value: "role") { [weak self] role in
                        guard let self = self else { return }
                        let castedRole = role as? String ?? ""
                        if castedRole == "coach" {
                            self.performSegue(withIdentifier: AppConstants.signInCoachTabSegue, sender: self)
                        } else if castedRole == "athlete" {
                            self.performSegue(withIdentifier: AppConstants.signInAthleteTabSegue, sender: self)
                        } else {
                            self.alertManager.showAlert(alertMessage: castedRole, viewController: self)
                        }
                    }
                }
            }
        }
    }

    private func showRoleSelectionAlert(for user: FirebaseAuth.User) {
        let alert = UIAlertController(title: "Welcome!", message: "We see that you're new. Are you a coach or an athlete?", preferredStyle: .alert)

        let splitFullName = user.displayName?.components(separatedBy: " ")
        let firstName = splitFullName?.first ?? ""
        let lastName = (splitFullName?.count ?? 0) > 1 ? (splitFullName?[1] ?? "") : ""

        alert.addAction(UIAlertAction(title: "Coach", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.firebaseManager.generateUniqueCoachId { [weak self] coachId in
                guard let self = self else { return }
                self.firebaseManager.createUserDocument(
                    firstName: firstName,
                    lastName: lastName,
                    role: "coach",
                    coachId: coachId,
                    email: user.email ?? "",
                    uid: user.uid
                )
            }
            self.performSegue(withIdentifier: AppConstants.signInCoachTabSegue, sender: self)
        })

        alert.addAction(UIAlertAction(title: "Athlete", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.firebaseManager.generateUniqueCoachId { [weak self] coachId in
                guard let self = self else { return }
                self.firebaseManager.createUserDocument(
                    firstName: firstName,
                    lastName: lastName,
                    role: "athlete",
                    coachId: coachId,
                    email: user.email ?? "",
                    uid: user.uid
                )
            }
            self.performSegue(withIdentifier: AppConstants.signInCodeSegue, sender: self)
        })

        present(alert, animated: true, completion: nil)
    }
}
