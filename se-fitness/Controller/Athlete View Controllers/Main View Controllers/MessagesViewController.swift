//
//  MessagesViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import UIKit
import Firebase

// MARK: - MessagesViewController

final class MessagesViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var coachNameLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var messageTextField: UITextField!
    @IBOutlet private weak var sendButton: UIButton!

    // MARK: - Properties

    private let firebaseManager = FirebaseManager.shared
    private var messages: [Message] = []
    private var messagesListener: ListenerRegistration?
    private var coachProfileImage: UIImage?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadCoachData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messagesListener?.remove()
    }

    // MARK: - Private Methods

    private func setupUI() {
        messageLabel.font = UIFont(name: "calibri", size: 15) ?? .systemFont(ofSize: 15)
        coachNameLabel.font = UIFont(name: "calibri-bold", size: 22) ?? .boldSystemFont(ofSize: 22)
        view.backgroundColor = .white
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: AppConstants.messageCellIdentifier, bundle: nil), forCellReuseIdentifier: AppConstants.messageCellIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
    }

    private func loadCoachData() {
        guard let currentUser = Auth.auth().currentUser else { return }
        firebaseManager.getUserData(uid: currentUser.uid, value: "coachName") { [weak self] coachName in
            guard let self = self else { return }
            self.coachNameLabel.text = coachName as? String ?? "Your coach"
        }
        loadMessages()
    }

    private func loadMessages() {
        guard let currentUser = Auth.auth().currentUser else { return }
        messagesListener = firebaseManager.listenToMessages(athleteId: currentUser.uid) { [weak self] messages in
            guard let self = self else { return }
            self.messages = messages
            self.tableView.reloadData()
            self.scrollToBottom()
        }
    }

    private func scrollToBottom() {
        guard !messages.isEmpty else { return }
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

    // MARK: - IBActions

    @IBAction private func sendButtonTapped(_ sender: UIButton) {
        guard let text = messageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !text.isEmpty,
              let currentUser = Auth.auth().currentUser else { return }

        let message = Message(
            id: "",
            text: text,
            timestamp: Date(),
            senderId: currentUser.uid,
            senderRole: "athlete"
        )

        firebaseManager.sendMessage(athleteId: currentUser.uid, message: message) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            }
        }

        firebaseManager.updateLastMessage(athleteId: currentUser.uid, message: text, timestamp: Date())
        messageTextField.text = ""
    }
}

// MARK: - UITableViewDataSource

extension MessagesViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.messageCellIdentifier, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        let message = messages[indexPath.row]
        let isFromCurrentUser = message.senderRole == "athlete"
        let profileImage = isFromCurrentUser ? nil : coachProfileImage
        cell.configure(message: message, profileImage: profileImage, isFromCurrentUser: isFromCurrentUser)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MessagesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
