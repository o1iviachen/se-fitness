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
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    private var conversations: [ConversationPreview] = []
    private let firebaseManager = FirebaseManager.shared

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadUserData()
        activityIndicator.startAnimating()
        loadConversations()
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
                self.nameLabel.text = "\(firstName)'s Messages"
            } else {
                self.nameLabel.text = "Your Messages"
            }
        }
    }

    private func loadConversations() {
        guard let currentUser = Auth.auth().currentUser else { return }
        firebaseManager.getAthletes(coachId: currentUser.uid) { [weak self] athletes in
            guard let self = self else { return }
            if athletes.isEmpty {
                // Add test data if no athletes linked
                #if DEBUG
                self.conversations = [
                    ConversationPreview(
                        athleteId: "test-athlete-1",
                        athleteName: "Olivia Chen",
                        lastMessage: "Calf doing better!",
                        image: UIImage(named: "test-monkey") ?? UIImage(systemName: "person.circle.fill")!
                    ),
                    ConversationPreview(
                        athleteId: "test-athlete-2",
                        athleteName: "Tony Chen",
                        lastMessage: "Ready for next workout",
                        image: UIImage(named: "test-monkey") ?? UIImage(systemName: "person.circle.fill")!
                    )
                ]
                #endif
            } else {
                self.conversations = athletes.map { athlete in
                    ConversationPreview(
                        athleteId: athlete.uid,
                        athleteName: "\(athlete.firstName) \(athlete.lastName)",
                        lastMessage: athlete.lastMessage ?? "No messages yet",
                        image: UIImage(named: "test-monkey") ?? UIImage(systemName: "person.circle.fill")!
                    )
                }
            }
            self.activityIndicator.stopAnimating()
            self.tableView.reloadData()
        }
    }

    private var selectedConversation: ConversationPreview?

    private func openChat(for conversation: ConversationPreview) {
        selectedConversation = conversation
        performSegue(withIdentifier: AppConstants.inboxToChatSegue, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.inboxToChatSegue,
           let chatVC = segue.destination as? MessagesViewController,
           let conversation = selectedConversation {
            chatVC.athleteId = conversation.athleteId
            chatVC.athleteName = conversation.athleteName
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
        cell.configure(recipient: conversation.athleteName, message: conversation.lastMessage, image: conversation.image)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension InboxViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let conversation = conversations[indexPath.row]
        openChat(for: conversation)
    }
}

