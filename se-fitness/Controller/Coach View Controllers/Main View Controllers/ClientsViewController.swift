//
//  ClientsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-21.
//

import UIKit
import Firebase

class ClientsViewController: UIViewController {
    
    let firebaseManager = FirebaseManager()
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var clientSelector: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeLabel.font = UIFont(name: "calibri-bold", size: 20)
        clientSelector.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "calibri", size: 12)!], for: .normal)
        firebaseManager.getUserData(uid: Auth.auth().currentUser!.uid, value: "firstName", completion: { firstName in
            if let firstName = firstName {
                self.welcomeLabel.text = "Hey, \(firstName) 👋"
            } else {
                self.welcomeLabel.text = "Hey! 👋"
            }
        })
    }
}
