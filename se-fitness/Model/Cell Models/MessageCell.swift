//
//  MessageCell.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-30.
//

import UIKit

// MARK: - MessageCell

final class MessageCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var bubbleView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!

    // Constraints for switching sender alignment
    @IBOutlet private weak var bubbleLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bubbleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var profileLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var profileTrailingConstraint: NSLayoutConstraint!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Private Methods

    private func setupUI() {
        profileImageView.layer.cornerRadius = 18
        profileImageView.clipsToBounds = true

        bubbleView.layer.cornerRadius = 16
        bubbleView.clipsToBounds = true
        bubbleView.backgroundColor = .systemGray5

        messageLabel.font = UIFont(name: "calibri", size: 15) ?? .systemFont(ofSize: 15)
        messageLabel.numberOfLines = 0

        timestampLabel.font = UIFont(name: "calibri", size: 11) ?? .systemFont(ofSize: 11)
        timestampLabel.textColor = .systemGray

        backgroundColor = .white
        selectionStyle = .none
    }

    // MARK: - Public Methods

    func configure(message: Message, profileImage: UIImage?, isFromCurrentUser: Bool) {
        messageLabel.text = message.text
        profileImageView.image = profileImage ?? UIImage(systemName: "person.circle.fill")

        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timestampLabel.text = formatter.string(from: message.timestamp)

        configureLayout(isFromCurrentUser: isFromCurrentUser)
    }

    private func configureLayout(isFromCurrentUser: Bool) {
        if isFromCurrentUser {
            // Message on the right, profile hidden or on right
            bubbleLeadingConstraint.priority = .defaultLow
            bubbleTrailingConstraint.priority = .required
            profileLeadingConstraint.priority = .defaultLow
            profileTrailingConstraint.priority = .required
            bubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            profileImageView.isHidden = true
        } else {
            // Message on the left with profile
            bubbleLeadingConstraint.priority = .required
            bubbleTrailingConstraint.priority = .defaultLow
            profileLeadingConstraint.priority = .required
            profileTrailingConstraint.priority = .defaultLow
            bubbleView.backgroundColor = .systemGray5
            messageLabel.textColor = .label
            profileImageView.isHidden = false
        }
    }
}
