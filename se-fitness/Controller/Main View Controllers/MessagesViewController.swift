//
//  MessagesViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {
    
    let firebaseManager = FirebaseManager()
    
    @IBOutlet weak var coachNameLabel: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        firebaseManager.getUserData(uid: Auth.auth().currentUser!.uid, value: "coachName", completion: { coachName in
            self.coachNameLabel.text = coachName as? String ?? "Your coach"
        })
    }
}
