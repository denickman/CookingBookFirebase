//
//  LoginViewModel.swift
//  CookBook
//
//  Created by Gwinyai Nyatsoka on 2/5/2024.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@Observable
class LoginViewModel {
    
    var presentRegisterView = false
    var showPassword = false
    var isLoading = false

    
    var email = ""
    var password = ""
    var errorMessage: AlertMessage? = nil
    
    func login() async -> User? {
        isLoading = true
        do {
           let result = try await Auth.auth().signIn(withEmail: email, password: password)
            // query to firebase
           let user = try await Firestore.firestore().collection("users").document(result.user.uid).getDocument(as: User.self)
            isLoading = false
            return user
        } catch let error {
            isLoading = false
            errorMessage = .init(text: "Login failed " + error.localizedDescription)
            let errorCode = error._code
           
            if let authErrorCode = AuthErrorCode(rawValue: errorCode) {
                
                switch authErrorCode {
                case .wrongPassword:
                    errorMessage = .init(text: "Wrong password")
                    
                case .invalidEmail:
                    errorMessage = .init(text: "invalid email")
                    
                default: break
                }
            }
            return nil
        }
    }
    
}
