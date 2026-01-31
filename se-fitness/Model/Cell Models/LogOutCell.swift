//
//  LogOutCell.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-07.
//

import UIKit

// MARK: - LogOutCell

final class LogOutCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var logOutLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        logOutLabel.font = UIFont(name: "calibri", size: 17)
    }
}
