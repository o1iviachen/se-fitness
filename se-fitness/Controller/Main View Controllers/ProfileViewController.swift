//
//  ProfileViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import UIKit
import Firebase

class ProfileViewController: BaseProfileViewController {
    /**
     A class that allows the Profile View Controller to display the user's profile information and settings. The information that it displays includes the user's email, fibre goal, and a list of available edits for the user's profile.
     
     - Properties:
        - tableView (Unwrapped UITableView): Displays the user's profile options.
        - userLabel (Unwrapped UILabel): Displays the user's email.
        - fibreLabel (Unwrapped UILabel): Displays the user's fibre goal.
     */
    
    let data = [[Setting(image: UIImage(systemName: "figure.indoor.soccer")!, setting: "Goals"), Setting(image: UIImage(systemName: "list.clipboard")!, setting: "Documents")], [Setting(image: UIImage(systemName: "questionmark.message")!, setting: "Contact")], ["Log out"]]
    let alertManager = AlertManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        /**
         Called after the View Controller is loaded to set up the Profile View Controller's Table View with custom cells.
         */
        
        firebaseManager.getUserData(uid: Auth.auth().currentUser!.uid, value: "workoutsCompleted") { numberOfWorkouts in
            self.viewControllerLabel.text = "🏆 \(numberOfWorkouts ?? 0) workouts completed"
        }
        
        super.viewDidLoad()
        
        // Set self as the table view's data source to provide the data
        tableView.dataSource = self
        
        // Set self as the table view's delegate to handle user interaction
        tableView.delegate = self
        
        // Register employed cells
        tableView.register(UINib(nibName: K.profileCellIdentifier, bundle: nil), forCellReuseIdentifier: K.profileCellIdentifier)
        tableView.register(UINib(nibName: K.logOutCellIdentifier, bundle: nil), forCellReuseIdentifier: K.logOutCellIdentifier)
        
        tableView.backgroundColor = .systemGray6
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: blockView.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource
extension ProfileViewController: UITableViewDataSource {
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
        return data.count
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
        return data[section].count
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
        if data[indexPath.section][indexPath.row] is Setting {
            let cellData = data[indexPath.section][indexPath.row] as! Setting
            let cell = tableView.dequeueReusableCell(withIdentifier: K.profileCellIdentifier, for: indexPath) as! ProfileCell
            
            // Set cell attributes as Setting attributes
            cell.label.text = cellData.setting
            cell.iconImage.image = cellData.image
            return cell
        }
        
        // Otherwise, create a log out cell
        else {
            let logOutCell = tableView.dequeueReusableCell(withIdentifier: K.logOutCellIdentifier, for: indexPath)
            return logOutCell
        }
    }
}

//MARK: - UITableViewDelegate
extension ProfileViewController: UITableViewDelegate {
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
        
        print(indexPath)
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
        else if indexPath == [0, 0] {
            performSegue(withIdentifier: K.profileGoalSegue, sender: self)
            print("hello")
        }
//        else if indexPath == [0, 1] {
//            performSegue(withIdentifier: K.profileSelectorSegue, sender: self)
//        } else if indexPath == [0, 0] {
//            performSegue(withIdentifier: K.profileCalculatorSegue, sender: self)
//        } else if indexPath == [1, 0] {
//            self.performSegue(withIdentifier: K.profileSupportSegue, sender: self)
//        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /**
         Sets the height for the header in each section in the Table View.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
            - section (Int): Specifies the section the header is for.
         
         - Returns: A CGFloat indicating the height of the header.
         */
        
        return 20.0
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /**
         Creates a transparent UI View to separate the different sections of the Table View.
         
         - Parameters:
            - tableVIew (UITableView): Requests this information.
            - section (Int): Specifieis the section the header is for.
         
         - Returns: An Optional UIView with a clear background for spacing and separation.
         */
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}
