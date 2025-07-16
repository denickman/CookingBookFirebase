//
//  SessionManager.swift
//  CookBook
//
//  Created by Gwinyai Nyatsoka on 4/5/2024.
//

import Foundation
import FirebaseAuth
import FirebaseCore


@Observable
class SessionManager {
    var sessionState: SessionState = .loggedOut
    var currentUser: User?
    
    init() {
        
        if FirebaseApp.allApps == nil {
            FirebaseApp.configure()
        }
        
        if Auth.auth().currentUser != nil {
            sessionState = .loggedIn
        } else {
            sessionState = .loggedOut
        }
    }
    
    
}
