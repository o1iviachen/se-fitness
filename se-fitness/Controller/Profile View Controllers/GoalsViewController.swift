//
//  GoalsViewController.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-19.
//

import Foundation

import UIKit
import Firebase

class GoalsViewController: BaseProfileViewController {
    
    let data: [Goal] = [Goal(title: "Squat 1RM", description: "225 pounds")]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        /**
         Called after the View Controller is loaded to set up the Profile View Controller's Table View with custom cells.
         */
        
        self.viewControllerLabel.text = "🚀 Goals"
        
        super.viewDidLoad()
        
        // Set self as the table view's data source to provide the data
        tableView.dataSource = self
        
        // Set self as the table view's delegate to handle user interaction
        tableView.delegate = self
        
        // Register employed cells
        tableView.register(UINib(nibName: K.goalCellIdentifier, bundle: nil), forCellReuseIdentifier: K.goalCellIdentifier)
        
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
extension GoalsViewController: UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.goalCellIdentifier, for: indexPath) as! GoalCell
        
        // Set cell attributes as Setting attributes
        cell.titleLabel.text = cellData.title
        cell.descriptionLabel.text = cellData.description
        return cell
    }
}

//MARK: - UITableViewDelegate
extension GoalsViewController: UITableViewDelegate {
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
        
        // Segue to corresponding view controller based on selected cell
        
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


