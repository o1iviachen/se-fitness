//
//  DocumentCell.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-20.
//

import UIKit

class DocumentCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pdfTitleLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: "calibri-bold", size: 17)
        commentLabel.font = UIFont(name: "calibri", size: 15)
        pdfTitleLabel.font = UIFont(name: "calibri", size: 17)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
