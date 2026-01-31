//
//  InboxViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-21.
//

import UIKit
import Firebase

// MARK: - InboxViewController

final class InboxViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private let conversations: [ConversationPreview] = [ConversationPreview(image: UIImage(named: "test-monkey") ?? UIImage(), recipient: "Olivia Chen", message: "Calf doing better.")]
    private let firebaseManager = FirebaseManager.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadUserData()
    }

    // MARK: - Private Methods

    private func setupUI() {
        nameLabel.font = UIFont(name: "calibri-bold", size: 22)
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: AppConstants.textCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.textCellIdentifier)
    }

    private func loadUserData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        firebaseManager.getUserData(uid: currentUser.uid, value: "firstName") { [weak self] firstName in
            guard let self = self else { return }
            if let firstName = firstName {
                self.nameLabel.text = "\(firstName)'s Messages 📬"
            } else {
                self.nameLabel.text = "Your Messages 📬"
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension InboxViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.textCellIdentifier, for: indexPath) as? TextCell else {
            return UITableViewCell()
        }
        let conversation = conversations[indexPath.row]
        cell.configure(recipient: conversation.recipient, message: conversation.message, image: conversation.image)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension InboxViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

