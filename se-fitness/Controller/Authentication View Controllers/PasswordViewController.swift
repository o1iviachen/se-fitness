//
//  PasswordViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-03.
//

import UIKit
import Firebase

// MARK: - PasswordViewController

final class PasswordViewController: BaseAuthenticationViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var resetButton: UIButton!

    // MARK: - Properties

    private let alertManager = AlertManager.shared
    var email: String? = ""

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        emailTextField.text = email
        resetButton.titleLabel?.font = UIFont(name: "calibri", size: 13)
        resetButton.layer.cornerRadius = 12
    }

    // MARK: - IBActions

    @IBAction private func sendEmailPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else { return }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] err in
            guard let self = self else { return }

            if let err = err {
                self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                return
            }

            Auth.auth().fetchSignInMethods(forEmail: email) { [weak self] signInMethods, err in
                guard let self = self else { return }

                if let err = err {
                    self.alertManager.showAlert(alertMessage: err.localizedDescription, viewController: self)
                    return
                }

                self.alertManager.showAlert(alertMessage: "please check your email to reset your password", viewController: self) { [weak self] in
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
