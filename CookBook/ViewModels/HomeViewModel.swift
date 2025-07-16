//
//  HomeViewModel.swift
//  CookBook
//
//  Created by Gwinyai Nyatsoka on 4/5/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable
class HomeViewModel {
    
    var showSignOutAlert = false
    var showAddReceipeView = false
    var receipes: [Receipe] = []
    
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func fetchReceipes() async {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        do {
           let receipesResult = try await Firestore.firestore().collection("receipes").whereField("userId", isEqualTo: userID)
                .getDocuments()
            
            receipes = receipesResult.documents.compactMap {
                Receipe(snapshot: $0)
            }
            
//            for receipeDocument in receipesResult.documents {
//                let data = receipeDocument.data()
//                
//                guard let imageLocation = data["image"] as? String else {
//                    continue
//                }
//                
//                guard let instruction = data["instructions"] as? String else {
//                    continue
//                }
//                
//                guard let name = data["name"] as? String else {
//                    continue
//                }
//                
//                guard let time = data["time"] as? Int else {
//                    continue
//                }
//                
//                guard let userId = data["userId"] as? String else {
//                    continue
//                }
//                
//                let id = receipeDocument.documentID
//                let receipe = Receipe(id: id, name: name, image: imageLocation, instructions: instruction, time: time, userId: userID)
//                
//                receipes.append(receipe)
//            } 
        } catch {
            
        }
        
   
    }
    
}
