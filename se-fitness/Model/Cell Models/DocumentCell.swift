//
//  DocumentCell.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-20.
//

import UIKit

// MARK: - DocumentCell

final class DocumentCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var pdfTitleLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "calibri-bold", size: 17)
        commentLabel.font = UIFont(name: "calibri", size: 15)
        pdfTitleLabel.font = UIFont(name: "calibri", size: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // MARK: - Public Methods

    func configure(title: String, comment: String, pdfTitle: String) {
        titleLabel.text = title
        commentLabel.text = comment
        pdfTitleLabel.text = pdfTitle
    }
}
