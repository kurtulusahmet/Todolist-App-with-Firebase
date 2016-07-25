//
//  NetworkingService.swift
//  
//
//  Created by Frezy Stone Mboumba on 7/1/16.
//
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import UIKit


struct NetworkingService {
    
    var databaseRef: FIRDatabaseReference! {
        return FIRDatabase.database().reference()
    }
    
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    
    
    // 3 --- Saving the user Info in the database
    private func saveInfo(user: FIRUser!, username: String, password: String, country: String){
        
        // Create our user dictionary info\
        
        let userInfo = ["email": user.email!, "username": username, "country": country, "uid": user.uid, "photoUrl": String(user.photoURL!)]
        
        // create user reference
        
        let userRef = databaseRef.child("users").child(user.uid)
        
        // Save the user info in the Database
        
        userRef.setValue(userInfo)
        
        
        // Signing in the user
        signIn(user.email!, password: password)
        
    }
    
    
    // 4 ---- Signing in the User
    func signIn(email: String, password: String){
        
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if error == nil {
                
                if let user = user {
                    
                    print("\(user.displayName!) has signed in succesfully!")
              
                }
                
            }else {
                
                print(error!.localizedDescription)
                
            }
        })
        
    }
    
    // 2 ------ Set User Info
    
    private func setUserInfo(user: FIRUser!, username: String, password: String, country: String, data: NSData!){
        
        //Create Path for the User Image
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        
        // Create image Reference
        
        let imageRef = storageRef.child(imagePath)
        
        // Create Metadata for the image
        
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        // Save the user Image in the Firebase Storage File
        
        imageRef.putData(data, metadata: metaData) { (metaData, error) in
            if error == nil {
                
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = username
                changeRequest.photoURL = metaData!.downloadURL()
                changeRequest.commitChangesWithCompletion({ (error) in
                    
                    if error == nil {
                       
                        self.saveInfo(user, username: username, password: password, country: country)
                                                
                    }else{
                        print(error!.localizedDescription)

                    }
                })
                
                
            }else {
                print(error!.localizedDescription)

            }
        }
        
        
        
        
        
    }
    // Reset Password
    func resetPassword(email: String){
        FIRAuth.auth()?.sendPasswordResetWithEmail(email, completion: { (error) in
            if error == nil {
                print("An email with information on how to reset your password has been sent to you. thank You")
            }else {
                print(error!.localizedDescription)
                
            }
        })
        
    }
    
    // 1 ---- We create the User
    
    func signUp(email: String, username: String, password: String, country: String, data: NSData!){
        
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            
            if error == nil {
                
                self.setUserInfo(user, username: username, password: password, country: country, data: data)
                
            }else {
                print(error!.localizedDescription)

            }
        })
        
        
    }
    
    
    
}
