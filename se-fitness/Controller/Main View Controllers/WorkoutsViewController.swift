//
//  WorkoutsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import UIKit
import Firebase

class WorkoutsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerBlock: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var workoutSelector: UISegmentedControl!
    
    
    let firebaseManager = FirebaseManager()
    let data = [Workout(completionImage: UIImage(systemName: "checkmark.circle")!, dateText: "August 7, 2025", workoutText:  "Thursday", exercises: [Exercise(orderText: "A", exerciseName: "Squats", descriptionText: "3x8")])]
    
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

//MARK: - UITableViewDataSource
extension WorkoutsViewController: UITableViewDataSource {
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
        return data.count
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
       
        let cellData = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.workoutCellIdentifier, for: indexPath) as! WorkoutCell
        
        // Set cell attributes as Setting attributes
        cell.workoutLabel.text = cellData.workoutText
        cell.completionImage = cellData.compleetionImage
        cell.dateLabel.text = cellData.dateText
        for exercise in cellData.exercises {
            exercise.descriptionText
        }
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: - UITableViewDelegate
extension WorkoutsViewController: UITableViewDelegate {
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
        
        // If log out button is pressed
        if indexPath == [2,0] {
            let alert = UIAlertController(title: "Are you sure?", message: "Do you want to log out?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            
            // Add a log out UIAlertAction with a handler to perform the segue
            let logOutAction = UIAlertAction(title: "Log out", style: .default) { (action) in
                do {
                    
                    // Sign user out
                    try Auth.auth().signOut()
                    
                    // Return to welcome view controller
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let delegate = windowScene.delegate as? SceneDelegate,
                       let window = delegate.window {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let welcomeVC = storyboard.instantiateViewController(withIdentifier: K.welcomeIdentifier)
                        window.rootViewController = welcomeVC
                        window.makeKeyAndVisible()
                    }
                }
                // If there is a sign out error, communicate to user there is an error
                catch let signOutError as NSError {
                    self.alertManager.showAlert(alertMessage: signOutError.localizedDescription, viewController: self)
                }
            }
            
            logOutAction.setValue(UIColor.red, forKey: "titleTextColor")
            alert.addAction(cancelAction)
            alert.addAction(logOutAction)
            
            // Present the alert
            self.present(alert, animated: true, completion: nil)
        }
        
        // Segue to corresponding view controller based on selected cell
//        else if indexPath == [0, 1] {
//            performSegue(withIdentifier: K.profileSelectorSegue, sender: self)
//        } else if indexPath == [0, 0] {
//            performSegue(withIdentifier: K.profileCalculatorSegue, sender: self)
//        } else if indexPath == [1, 0] {
//            self.performSegue(withIdentifier: K.profileSupportSegue, sender: self)
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
