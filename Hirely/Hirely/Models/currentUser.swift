//
//  currentUser.swift
//  Hirely
//
//  Created by Mayar Sakhnini on 26/12/2024.
//

import Foundation
import FirebaseAuth

struct currentUser{
    func getCurrentUserId() -> String? {
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            print("No user is signed in.")
            return nil
        }
    }
}
