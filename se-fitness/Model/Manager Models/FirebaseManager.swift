//
//  FirebaseManager.swift
//  se-fitness
//
//  Created by olivia chen on 2025-07-05.
//

import Firebase


struct FirebaseManager {
    let db = Firestore.firestore()
    let alertManager = AlertManager()
    
//    func fetchUserDocument(completion: @escaping (DocumentSnapshot?) -> Void) {
//        /**
//         Fetches a Firebase Firestore document authorized through the user's email.
//         
//         - Parameters:
//            - completion (Optional DocumentSnapshot): Stores the Firebase Firestore information at the time of the call.
//         */
//        
//        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { document, error in
//            
//            // If an error occurs in fetching document, call completion handler with no document snapshot (nil); code from https://cloud.google.com/firestore/docs/manage-data/add-data
//            guard let document = document else {
//                completion(document)
//                return
//            }
//            
//            // If the document is empty, call completion handler with no document snapshot (nil)
//            guard document.data() != nil else {
//                completion(document)
//                return
//            }
//            
//            completion(document)
//        }
//    }
    
    func createUserDocument(firstName: String, lastName: String, role: String, coachId: String?, email: String, uid: String) {
        var userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
            "role": role,
            "coachId": coachId ?? "",
            "workoutsCompleted": 0,
            "createdAt": Timestamp()
        ]
        
        if role == "coach" {
            userData["athletes"] = [:]
        }
        
        db.collection("users").document(uid).setData(userData) { error in
            if let error = error {
                print("Error writing user document: \(error)")
            } 
        }
    }
    
    
    
    func getUserData(uid: String, value: String, completion: @escaping (Any?) -> Void) {
        db.collection("users").document(uid).getDocument { document, error in
            if let error = error {
                completion(error.localizedDescription)
            } else {
                if let data = document?.data() {
                    let role = data[value] as? String
                    completion(role)
                } else {
                    completion("Role does not exist")
                }
            }
        }
    }
    
    func generateUniqueCoachId(completion: @escaping (String?) -> Void) {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let coachId = String((0..<6).map { _ in characters.randomElement()! })
        
        db.collection("users").whereField("coachId", isEqualTo: coachId).getDocuments { snapshot, error in
            if let error = error {
                completion(nil) // or completion(error.localizedDescription) if you want to return the error string
            } else if snapshot?.isEmpty == true {
                completion(coachId)
            } else {
                // Try again if not unique
                generateUniqueCoachId(completion: completion)
            }
        }
    }
    
    func confirmCoach(code: String, completion: @escaping (String?) -> Void) {
        db.collection("users").whereField("coachId", isEqualTo: code).whereField("role", isEqualTo: "coach").getDocuments { snapshot, error in
            if let error = error {
                completion(error.localizedDescription)
            } else if let doc = snapshot?.documents.first {
                let coachFirstName = doc.get("firstName") as? String ?? ""
                let coachLastName = doc.get("lastName") as? String  ?? ""
                completion("\(coachFirstName) \(coachLastName)")
            } else {
                completion(nil)
            }
        }
    }
    
    func addAthlete(athleteUid: String, code: String, completion: @escaping (String?) -> Void) {
        db.collection("users").whereField("coachId", isEqualTo: code).whereField("role", isEqualTo: "coach").getDocuments { snapshot, error in
            if let error = error {
                completion(error.localizedDescription)
            } else if let doc = snapshot?.documents.first {
                let athleteData = ["workouts": [], "documents": []]
                doc.reference.updateData(["athletes.\(athleteUid)" : athleteData]) { error in
                    if let error = error {
                        print("Error writing to user document: \(error)")
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
}
