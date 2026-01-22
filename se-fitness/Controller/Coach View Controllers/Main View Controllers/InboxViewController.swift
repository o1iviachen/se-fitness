//
//  InboxViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-21.
//

import UIKit
import Firebase

class InboxViewController: UIViewController {
        
    let messages: [Message] = [Message(image: UIImage(named: "test-monkey")!, recipient: "Olivia Chen", message: "Calf doing better.")]
    
    let firebaseManager = FirebaseManager()
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.font = UIFont(name: "calibri-bold", size: 22)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: K.textCellIdentifier, bundle: nil), forCellReuseIdentifier: K.textCellIdentifier)
        
        firebaseManager.getUserData(uid: Auth.auth().currentUser!.uid, value: "firstName", completion: { firstName in
            if let firstName = firstName {
                self.nameLabel.text = "\(firstName)'s Messages 📬"
            } else {
                self.nameLabel.text = "Your Messages 📬"
            }
        })
    }
}

//MARK: - UITableViewDataSource
extension InboxViewController: UITableViewDataSource {
    /**
     An extension that specifies the sections, rows, and cells for the Table View.
     */
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        /**
         Returns the number of sections needed.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
         
         - Returns: An Int indicating the number of sections.
         */
        
        // Required to populate the correct number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /**
         Returns the number of rows for a given section.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
            - section (Int): Indicates the section.
         
         - Returns: An Int indicating the number of rows.
         */
        
        // Required to populate the correct number of cells per section
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /**
         Sets up and return the cell for a given section and row.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
            - indexPath(IndexPath): Specifies the section and row.
         
         - Returns: A UITableViewCell with the correct formal and information.
         */
        
        // If the element is a Setting, create a Profile cell
        let cellData = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.textCellIdentifier, for: indexPath)
        
        as! TextCell
        
        // Set cell attributes as Setting attributes
        cell.recipientLabel.text = cellData.recipient
        cell.messageLabel.text = cellData.message
        cell.profileImageView.image = cellData.image
        return cell
    }
}

//MARK: - UITableViewDelegate
extension InboxViewController: UITableViewDelegate {
    /**
     An extention that allows the user to edit their profile.
     */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /**
         Performs different actions based on the cell that the user selects, including navigating and logging out.
         
         - Parameters:
            - tableView (UITableView): Informs the delegate of the row selection.
            - indexPath (IndexPath): Specifies the row the user selected.
         */
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

