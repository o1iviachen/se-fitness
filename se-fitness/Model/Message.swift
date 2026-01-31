//
//  Message.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-30.
//

import Foundation
import Firebase

struct Message {
    /**
     A structure representing a chat message stored in Firebase.

     Stored at: users/{athleteId}/messages/{messageId}

     - Properties:
         - id: The Firestore document ID.
         - text: The message content.
         - timestamp: When the message was sent.
         - senderId: The UID of the sender.
         - senderRole: Either "coach" or "athlete".
         - read: Whether the message has been read by the recipient.
     */

    let id: String
    let text: String
    let timestamp: Date
    let senderId: String
    let senderRole: String
    let read: Bool

    // MARK: - Initializers

    init(id: String, text: String, timestamp: Date, senderId: String, senderRole: String, read: Bool = false) {
        self.id = id
        self.text = text
        self.timestamp = timestamp
        self.senderId = senderId
        self.senderRole = senderRole
        self.read = read
    }

    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        guard let text = data["text"] as? String,
              let timestamp = data["timestamp"] as? Timestamp,
              let senderId = data["senderId"] as? String,
              let senderRole = data["senderRole"] as? String else {
            return nil
        }

        self.id = document.documentID
        self.text = text
        self.timestamp = timestamp.dateValue()
        self.senderId = senderId
        self.senderRole = senderRole
        self.read = data["read"] as? Bool ?? false
    }

    // MARK: - Firebase Dictionary

    var dictionary: [String: Any] {
        return [
            "text": text,
            "timestamp": Timestamp(date: timestamp),
            "senderId": senderId,
            "senderRole": senderRole,
            "read": read
        ]
    }
}
