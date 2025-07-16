//
//  AddReceipeViewModel.swift
//  CookBook
//
//  Created by Gwinyai Nyatsoka on 6/5/2024.
//

import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

@Observable
class AddReceipeViewModel {
    
    var receipeName = ""
    var preparationTime = 0
    var instructions = ""
    var showImageOptions = false
    var showLibrary = false
    
    var displayedReceipeImage: Image?
    var showCamera = false
    var receipeImage: UIImage?
    var uploadProgress: Float = 0
    var isUploading = false
    var isLoading = false
    var showAlert = false
    var alertTitle = ""
    var alertMessage = ""
    
    
    func upload() async -> URL? {
        // images/userId/image.jpeg
        
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return nil
        }
        
        guard let receipeImage = receipeImage,
        let imageData = receipeImage.jpegData(compressionQuality: 0.7) else {
            createAlert(title: "Image Upload Failed", message: "Your receipe image could not be uploaded.")
            return nil
        }

        let imageID = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
        let imageName = "\(imageID).jpeg"
        let imagePath = "images/\(userId)/\(imageName)"
        
        let storageRef = Storage.storage().reference(withPath: imagePath)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        isUploading = true
        
        do {
           _ = try await storageRef.putDataAsync(imageData, metadata: metaData) { progress in
                if let progress = progress {
                    let percentComplete = Float(progress.completedUnitCount / progress.totalUnitCount)
                    self.uploadProgress = percentComplete
                }
            }
            isUploading = false
            let downloadURL = try await storageRef.downloadURL()
            return downloadURL
        } catch {
            createAlert(title: "Image Upload Failed", message: "Your receipe image could not be uploaded.")

            isUploading = false
            return nil
        }
    }
    
    
    func addReceipe(imageURL: URL, completion: @escaping (Bool) -> Void) {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            createAlert(title: "Not signed in", message: "Please sign in to create recepies")
            return completion(false)
        }
        
        guard receipeName.count >= 2 else {
            createAlert(title: "Invalid Receipe Name", message: "Receipe name must be 2 or more characters long")
            return completion(false)
        }
        
        guard instructions.count >= 5 else {
            createAlert(title: "Invalid instructions", message: "Instructions must be 5 or more characters long")
            return completion(false)
        }
        
        guard preparationTime != 0 else {
            createAlert(title: "Invalid Preparation Time", message: "Preparation must be greater than 0 minutes.")
            return completion(false)
        }
        
        // Загрузка изображения:
//        guard let url = await upload() else {
//            return completion(false)
//        }
        
        isLoading = true
        
        // Загрузка изображения:
        let ref = Firestore.firestore().collection("receipes").document().documentID
        let receipe = Receipe(id: ref, name: receipeName, image: imageURL.absoluteString, instructions: instructions, time: preparationTime, userId: userId)
        
        // save to firebase
        do {
            try Firestore.firestore().collection("receipes").document(ref).setData(from: receipe) { error in
                self.isLoading = false
                if let error {
                    print(error.localizedDescription)
                    self.createAlert(title: "Could not save receipe", message: "Cannot save your receipe right now, please try again later.")
                    completion(false)
                    return
                }
              
                completion(true)
            }
   
        } catch {
            createAlert(title: "Could not save receipe", message: "Cannot save your receipe right now, please try again later.")
            isLoading = false
            completion(false)
        }

    }
    
    
    private func createAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
