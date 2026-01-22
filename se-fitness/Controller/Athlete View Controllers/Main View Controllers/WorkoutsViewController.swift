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
    @IBOutlet weak var monthSelector: UIView!
    @IBOutlet weak var targetViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: NSLayoutConstraint!
    
    let data = [Workout(completionImage: UIImage(systemName: "checkmark.circle")!, date: Date(), workoutText:  "Thursday", exercises: [Exercise(orderText: "A", exerciseName: "Squats", descriptionText: "3x8")])]
    var filteredData: [Workout] = []

    let dateManager = DateManager()
    let firebaseManager = FirebaseManager()
    var currentDate = Date()
    
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
        
        monthLabel.font = UIFont(name: "calibri", size: 17)!
        monthLabel.text = dateManager.convertToString(date: currentDate, stringFormat: "MMMM yyyy")
        welcomeLabel.font = UIFont(name: "calibri-bold", size: 20)
        welcomeLabel.sizeToFit()
        targetViewHeightConstraint.constant = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.workoutCellIdentifier, bundle: nil), forCellReuseIdentifier: K.workoutCellIdentifier)
        tableView.backgroundColor = .systemGray6
        updateFilteredData()
        tableView.reloadData()
    }
    
    @IBAction func timeSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            monthSelector.isHidden = true
            targetViewHeightConstraint.constant = 0

        } else {
            monthSelector.isHidden = false
            targetViewHeightConstraint.constant = 60
        }
        updateFilteredData()
        tableView.reloadData()
    }
    
    @IBAction func nextMonth(_ sender: UIButton) {
        if !Calendar.current.isDate(currentDate, equalTo: Date(), toGranularity: .month) {
            currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate)!
            monthLabel.text = dateManager.convertToString(date: currentDate, stringFormat: "MMMM yyyy")
            updateFilteredData()
            tableView.reloadData()
        }
    }
        
    @IBAction func pastMonth(_ sender: UIButton) {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        monthLabel.text = dateManager.convertToString(date: currentDate, stringFormat: "MMMM yyyy")
        updateFilteredData()
        tableView.reloadData()
    }
    
    func updateFilteredData() {
        if workoutSelector.selectedSegmentIndex == 0 {
            filteredData = data.filter { $0.date >= dateManager.todayAtMidnight() }
        } else {
            // workouts in the selected month
            filteredData = data.filter {
                Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .month) &&
                Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .year)
            }
        }
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
        return filteredData.count
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
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /**
         Sets up and return the cell for a given section and row.
         
         - Parameters:
            - tableView (UITableView): Requests this information.
            - indexPath(IndexPath): Specifies the section and row.
         
         - Returns: A UITableViewCell with the correct formal and information.
         */
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.workoutCellIdentifier, for: indexPath) as! WorkoutCell
        let cellData = filteredData[indexPath.section]

        cell.workoutLabel.text = cellData.workoutText
        cell.completionImage.image = cellData.completionImage
        cell.dateLabel.text = dateManager.convertToString(date: cellData.date, stringFormat: "MMMM dd, yyyy")
        cell.data = cellData.exercises
        
        return cell
    
    }
}

//MARK: - UITableViewDelegate
extension WorkoutsViewController: UITableViewDelegate {
    /**
     An extension that allows the user to edit their profile.
     */
    
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
