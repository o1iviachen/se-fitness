//
//  SignUpViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-01.
//

import UIKit
import Firebase
import GoogleSignIn

// MARK: - SignUpViewController

final class SignUpViewController: BaseAuthenticationViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var roleSelector: UISegmentedControl!
    @IBOutlet private weak var signUpButton: UIButton!
    @IBOutlet private weak var googleSignUpButton: UIButton!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!

    // MARK: - Properties

    private let alertManager = AlertManager.shared
    private let firebaseManager = FirebaseManager.shared
    private let db = Firestore.firestore()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        let buttons = [signUpButton, googleSignUpButton]
        let textFields = [firstNameTextField, lastNameTextField, emailTextField, passwordTextField, confirmPasswordTextField]

        roleSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "calibri", size: 12) ?? .systemFont(ofSize: 12)], for: .normal)

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
    
    @IBAction private func signUpPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmedPassword = confirmPasswordTextField.text else { return }

        guard password == confirmedPassword else {
            alertManager.showAlert(alertMessage: "⚠️ Passwords do not match!", viewController: self)
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, err in
            guard let self = self else { return }

            if let err = err {
                if err.localizedDescription != "The user canceled the sign-in flow." {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                }
                return
            }

            guard let user = authResult?.user else { return }

            let userRole = self.roleSelector.selectedSegmentIndex == 0 ? "coach" : "athlete"
            if userRole == "coach" {
                self.performSegue(withIdentifier: AppConstants.signUpCoachTabSegue, sender: self)
                self.firebaseManager.generateUniqueCoachId { [weak self] coachId in
                    guard let self = self else { return }
                    self.firebaseManager.createUserDocument(
                        firstName: self.firstNameTextField.text ?? "",
                        lastName: self.lastNameTextField.text ?? "",
                        role: userRole,
                        coachId: coachId,
                        email: email,
                        uid: user.uid
                    )
                }
            } else if userRole == "athlete" {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: AppConstants.signUpCodeSegue, sender: self)
                }
                self.firebaseManager.createUserDocument(
                    firstName: self.firstNameTextField.text ?? "",
                    lastName: self.lastNameTextField.text ?? "",
                    role: userRole,
                    coachId: "",
                    email: email,
                    uid: user.uid
                )
            }
        }
    }
    
    
    @IBAction private func googleSignUpPressed(_ sender: UIButton) {
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

            Auth.auth().signIn(with: credential) { [weak self] result, err in
                guard let self = self else { return }

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
                let lastName = (splitFullName?.count ?? 0) > 1 ? (splitFullName?[1] ?? "") : ""

                guard let isNewUser = result?.additionalUserInfo?.isNewUser else { return }

                if isNewUser {
                    let userRole = self.roleSelector.selectedSegmentIndex == 0 ? "coach" : "athlete"
                    self.firebaseManager.generateUniqueCoachId { [weak self] coachId in
                        guard let self = self else { return }
                        self.firebaseManager.createUserDocument(
                            firstName: firstName,
                            lastName: lastName,
                            role: userRole,
                            coachId: coachId,
                            email: user.email ?? "",
                            uid: user.uid
                        )
                    }
                    if userRole == "coach" {
                        self.performSegue(withIdentifier: AppConstants.signUpCoachTabSegue, sender: self)
                    } else if userRole == "athlete" {
                        self.performSegue(withIdentifier: AppConstants.signUpCodeSegue, sender: self)
                    }
                } else {
                    self.performSegue(withIdentifier: AppConstants.signUpAthleteTabSegue, sender: self)
                }
            }
        }
    }
}
