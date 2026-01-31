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

    // MARK: - Public Properties (for coach view)

    var athleteId: String?
    var athleteName: String?

    // MARK: - Private Properties

    private let firebaseManager = FirebaseManager.shared
    private var messages: [Message] = []
    private var messagesListener: ListenerRegistration?
    private var otherUserProfileImage: UIImage?

    private var isCoachView: Bool {
        return athleteId != nil
    }

    private var currentRole: String {
        return isCoachView ? "coach" : "athlete"
    }

    private var targetAthleteId: String {
        return athleteId ?? Auth.auth().currentUser?.uid ?? ""
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadHeaderData()
        loadMessages()

        #if DEBUG
        addDebugGesture()
        #endif
    }

    #if DEBUG
    private func addDebugGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(createTestMessages))
        longPress.minimumPressDuration = 2.0
        view.addGestureRecognizer(longPress)
    }

    @objc private func createTestMessages(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began,
              let currentUser = Auth.auth().currentUser else { return }

        let testMessages = [
            Message(id: "", text: "Hey! How's your training going?", timestamp: Date().addingTimeInterval(-3600), senderId: "coach123", senderRole: "coach"),
            Message(id: "", text: "Going well! My calf is feeling much better.", timestamp: Date().addingTimeInterval(-3000), senderId: currentUser.uid, senderRole: "athlete"),
            Message(id: "", text: "Great to hear! Let's increase intensity next week.", timestamp: Date().addingTimeInterval(-2400), senderId: "coach123", senderRole: "coach"),
            Message(id: "", text: "Sounds good, I'm ready for it!", timestamp: Date().addingTimeInterval(-1800), senderId: currentUser.uid, senderRole: "athlete")
        ]

        for message in testMessages {
            firebaseManager.sendMessage(athleteId: targetAthleteId, message: message) { error in
                if let error = error {
                    print("Error creating test message: \(error.localizedDescription)")
                }
            }
        }

        let alert = UIAlertController(title: "Debug", message: "Created 4 test messages", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    #endif

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        messagesListener?.remove()
    }

    // MARK: - Private Methods

    private func setupUI() {
        messageLabel?.font = UIFont(name: "calibri", size: 15) ?? .systemFont(ofSize: 15)
        coachNameLabel?.font = UIFont(name: "calibri-bold", size: 22) ?? .boldSystemFont(ofSize: 22)
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

    private func loadHeaderData() {
        if isCoachView {
            coachNameLabel?.text = athleteName ?? "Athlete"
            messageLabel?.text = "Chat with athlete"
        } else {
            guard let currentUser = Auth.auth().currentUser else { return }
            firebaseManager.getUserData(uid: currentUser.uid, value: "coachName") { [weak self] coachName in
                guard let self = self else { return }
                self.coachNameLabel?.text = coachName as? String ?? "Your coach"
            }
        }
    }

    private func loadMessages() {
        messagesListener = firebaseManager.listenToMessages(athleteId: targetAthleteId) { [weak self] messages in
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
            senderRole: currentRole
        )

        firebaseManager.sendMessage(athleteId: targetAthleteId, message: message) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            }
        }

        firebaseManager.updateLastMessage(athleteId: targetAthleteId, message: text, timestamp: Date())
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
        let isFromCurrentUser = message.senderRole == currentRole
        let profileImage = isFromCurrentUser ? nil : otherUserProfileImage
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
