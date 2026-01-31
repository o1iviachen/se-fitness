//
//  ConversationPreview.swift
//  se-fitness
//
//  Created by olivia chen on 2026-01-21.
//

import UIKit

struct ConversationPreview {
    /**
     A structure for displaying conversation previews in the inbox.

     - Properties:
         - athleteId (String): The UID of the athlete for loading their messages.
         - athleteName (String): The name of the athlete.
         - lastMessage (String): Preview of the last message.
         - image (UIImage): The athlete's profile image.
     */

    let athleteId: String
    let athleteName: String
    let lastMessage: String
    let image: UIImage
}
