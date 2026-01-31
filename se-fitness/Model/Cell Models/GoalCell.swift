//
//  GoalCell.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-19.
//

import UIKit

// MARK: - GoalCell

final class GoalCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "calibri-bold", size: 17)
        descriptionLabel.font = UIFont(name: "calibri", size: 15)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Public Methods

    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
}
