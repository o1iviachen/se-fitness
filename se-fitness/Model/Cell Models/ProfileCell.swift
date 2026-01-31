//
//  ProfileCell.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-06.
//

import UIKit

// MARK: - ProfileCell

final class ProfileCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var iconImage: UIImageView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = UIFont(name: "calibri", size: 17)
    }

    // MARK: - Public Methods

    func configure(setting: String, image: UIImage) {
        label.text = setting
        iconImage.image = image
    }
}
