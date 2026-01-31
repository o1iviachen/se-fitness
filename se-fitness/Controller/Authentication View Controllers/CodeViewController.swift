//
//  CodeViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-10.
//

import UIKit
import Firebase

// MARK: - CodeViewController

final class CodeViewController: BaseAuthenticationViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var welcomeLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var codeTextField: UITextField!
    @IBOutlet private weak var enterButton: UIButton!

    // MARK: - Properties

    private let firebaseManager = FirebaseManager.shared
    private let alertManager = AlertManager.shared
    private let db = Firestore.firestore().collection("users")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        let uiComponents: [UILabel] = [welcomeLabel, codeLabel]
        for uiComponent in uiComponents {
            uiComponent.font = UIFont(name: "calibri", size: 17)
        }
        codeTextField.font = UIFont(name: "calibri", size: 17)
        enterButton.titleLabel?.font = UIFont(name: "calibri", size: 17)
        enterButton.layer.cornerRadius = 12
    }

    // MARK: - IBActions

    @IBAction private func enterPressed(_ sender: UIButton) {
        guard let code = codeTextField.text, !code.isEmpty else {
            alertManager.showAlert(alertMessage: "Please enter a code.", viewController: self)
            return
        }

        firebaseManager.confirmCoach(code: code) { [weak self] result in
            guard let self = self else { return }

            guard let coachName = result else {
                self.alertManager.showAlert(alertMessage: "We could not find a coach with this code. Please try again.", viewController: self)
                return
            }

            guard let athleteUid = Auth.auth().currentUser?.uid else { return }

            self.db.document(athleteUid).setData(["coachId": code, "coachName": coachName], merge: true)
            self.firebaseManager.addAthlete(athleteUid: athleteUid, code: code) { [weak self] errorMessage in
                guard let self = self else { return }
                if let errorMessage = errorMessage {
                    self.alertManager.showAlert(alertMessage: errorMessage, viewController: self)
                }
            }
            self.performSegue(withIdentifier: AppConstants.codeTabSegue, sender: self)
        }
    }
}
