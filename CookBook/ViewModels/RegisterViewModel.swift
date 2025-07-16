//
//  RegisterViewModel.swift
//  CookBook
//
//  Created by Gwinyai Nyatsoka on 3/5/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AlertMessage: Identifiable {
    let id = UUID()
    let text: String
}

@Observable
class RegisterViewModel {
    
    var username = ""
    var email = ""
    var showPassword = false
    var password = ""
    var isLoading = false
    var errorMessage: AlertMessage? = nil
    
    func signUp() async -> User? {
        print("sign up>>")
        
        guard validateUsername() else {
            errorMessage = .init(text: "username must be greated then 3 characters and less thena 5 characters")
            return nil
        }
        
        isLoading = true
        
        // launch the reqeust to check if such user is already exist
        guard let usernameDocuments = try? await Firestore.firestore().collection("users").whereField("username", isEqualTo: username).getDocuments() else {
            errorMessage = .init(text: "Something has gone wrong. Please try again later.")
            isLoading = false
            return nil
        }
        
        
        guard usernameDocuments.documents.count == 0 else {
            errorMessage = .init(text: "username already exist")
            isLoading = false
            return nil
        }
        
        do {
            isLoading = true
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let userID = result.user.uid
            
            //            let userData: [String: Any] = [
            //                "username": username,
            //                "email": email
            //            ]
            
            let user = User(id: userID, username: username, email: email)
            
            try Firestore.firestore().collection("users")
                .document(userID)
                .setData(from: user)
            
            isLoading = false
            
            return user
        } catch (let error) {
            errorMessage = .init(text: "Registration failed")
            
            let errorCode = error._code
            isLoading = false
            
            if let authErrorCode = AuthErrorCode(rawValue: errorCode) {
                switch authErrorCode {
                case .emailAlreadyInUse:
                    errorMessage = .init(text: "Email already used")
                    
                case .wrongPassword:
                    errorMessage = .init(text: "Password is wrong")
                    
                case .weakPassword:
                    errorMessage = .init(text: "Password too short")
                    
                default:
                    break
                }
            }
            return nil
        }
        
    }
    
    func validateUsername() -> Bool {
        username.count >= 3 && username.count < 25
    }
}
