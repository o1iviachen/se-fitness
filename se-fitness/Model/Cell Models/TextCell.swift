//
//  TextCell.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-21.
//

import UIKit

// MARK: - TextCell

final class TextCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var recipientLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        recipientLabel.font = UIFont(name: "calibri-bold", size: 17)
        messageLabel.font = UIFont(name: "calibri", size: 15)
    }

    // MARK: - Public Methods

    func configure(recipient: String, message: String, image: UIImage?) {
        recipientLabel.text = recipient
        messageLabel.text = message
        profileImageView.image = image
    }
}
