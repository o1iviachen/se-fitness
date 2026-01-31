//
//  ContactViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-20.
//

import UIKit
import MessageUI
import Firebase

// MARK: - ContactViewController

final class ContactViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var questionsLabel: UILabel!
    @IBOutlet private weak var viewHolder: UIView!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var sendButton: UIButton!

    // MARK: - Properties

    private let alertManager = AlertManager.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGestures()
    }

    // MARK: - Private Methods

    private func setupUI() {
        questionsLabel.font = UIFont(name: "calibri-bold", size: 17)
        sendButton.titleLabel?.font = UIFont(name: "calibri", size: 17)
        textView.font = UIFont(name: "calibri", size: 17)
        sendButton.layer.cornerRadius = 12
        viewHolder.layer.cornerRadius = 10
        viewHolder.layer.masksToBounds = true
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }

    // MARK: - IBActions

    @IBAction private func sendButtonTapped(_ sender: UIButton) {
        guard let text = textView.text, !text.isEmpty else {
            alertManager.showAlert(alertMessage: "email body is empty.", viewController: self)
            return
        }
        sendEmail(body: text, controller: self)
    }

    @objc private func handleSwipe() {
        textView.resignFirstResponder()
    }

    @objc private func handleTap() {
        textView.resignFirstResponder()
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension ContactViewController: MFMailComposeViewControllerDelegate {

    func sendEmail(body: String, controller: ContactViewController) {
        guard MFMailComposeViewController.canSendMail() else {
            alertManager.showAlert(alertMessage: "unable to send email.", viewController: self)
            return
        }

        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = controller

        if let currentUserEmail = Auth.auth().currentUser?.email {
            mailComposer.setPreferredSendingEmailAddress(currentUserEmail)
        }
        mailComposer.setToRecipients(["olivia63chen@gmail.com"])
        mailComposer.setSubject("Inquiry about SE Fitness.")
        mailComposer.setMessageBody(body, isHTML: false)
        controller.present(mailComposer, animated: true, completion: nil)
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            controller.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.alertManager.showAlert(alertMessage: "email sent!", viewController: self)
            }
        case .saved:
            controller.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.alertManager.showAlert(alertMessage: "email saved!", viewController: self)
            }
        case .cancelled:
            controller.dismiss(animated: true, completion: nil)
        case .failed:
            controller.dismiss(animated: true) { [weak self] in
                guard let self = self else { return }
                self.alertManager.showAlert(alertMessage: "the email was not sent.", viewController: self)
            }
        @unknown default:
            break
        }
    }
}
