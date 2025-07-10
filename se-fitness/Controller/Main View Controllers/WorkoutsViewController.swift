//
//  WorkoutsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import UIKit
import Firebase

class WorkoutsViewController: UIViewController {
    
    
    @IBOutlet weak var headerBlock: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var workoutSelector: UISegmentedControl!
    
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        workoutSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "calibri", size: 12)!], for: .normal)
        firebaseManager.getUserData(uid: Auth.auth().currentUser!.uid, value: "firstName", completion: { firstName in
            if let firstName = firstName {
                self.welcomeLabel.text = "Hey, \(firstName) 👋"
            } else {
                self.welcomeLabel.text = "Hey! 👋"
            }
        })
        welcomeLabel.font = UIFont(name: "calibri-bold", size: 20)
        welcomeLabel.sizeToFit()
    }
}
