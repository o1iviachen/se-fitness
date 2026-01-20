//
//  Workout.swift
//  se-fitness
//
//  Created by olivia chen on 2025-08-20.
//

import UIKit

struct Workout {
    /**
     A structure that allows the user to set up their profile.
     
     - Properties:
         - image (UIImage): The user's profile image.
         - setting (String): A label usable for multiple setting buttons.
     */
    
    let completionImage: UIImage
    let date: Date
    let workoutText: String
    let exercises: [Exercise]

}
