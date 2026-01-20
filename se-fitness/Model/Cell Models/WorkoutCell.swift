//
//  WorkoutCell.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-13.
//

import UIKit

class WorkoutCell: UITableViewCell {

    @IBOutlet weak var exerciseTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var completionImage: UIImageView!
    @IBOutlet weak var workoutLabel: UILabel!
    @IBOutlet weak var exerciseTable: UITableView!
    var data: [Exercise] = [] {
        didSet {
            exerciseTable.reloadData()
            let rowHeight = 45
            exerciseTableHeightConstraint.constant = CGFloat(data.count * rowHeight)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let labels: [UILabel] = [dateLabel, workoutLabel]
        for label in labels {
            label.font = UIFont(name: "calibri", size: 17)
        }
        
        exerciseTable.register(UINib(nibName: K.exerciseCellIdentifier, bundle: nil), forCellReuseIdentifier: K.exerciseCellIdentifier)
        
        // Set self as the table view's data source to provide the data
        exerciseTable.dataSource = self
        
        // Set self as the table view's delegate to handle user interaction
        exerciseTable.delegate = self
    }
    
}

//MARK: - UITableViewDataSource
extension WorkoutCell: UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: K.exerciseCellIdentifier, for: indexPath) as! ExerciseCell
            
            // Set cell attributes as Setting attributes
        cell.orderLabel.text = cellData.orderText
        cell.exerciseName.text = cellData.exerciseName
        return cell
    }
}

//MARK: - UITableViewDelegate
extension WorkoutCell: UITableViewDelegate {
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

