//
//  WorkoutsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import UIKit

class WorkoutsViewController: UIViewController {
    
    
    @IBOutlet weak var headerBlock: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var workoutSelector: UISegmentedControl!
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        workoutSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "calibri", size: 12)!], for: .normal)
        welcomeLabel.font = UIFont(name: "calibri-bold", size: 20)
        welcomeLabel.sizeToFit()
    }
}
