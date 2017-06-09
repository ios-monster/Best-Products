//
//  Product.swift
//  Best products
//
//  Created by Ashot on 5/24/17.
//  Copyright © 2017 ios.monster. All rights reserved.



import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import UIKit


struct NetworkService {
  
  var databaseRef: FIRDatabaseReference! {
    return FIRDatabase.database().reference()
  }
  
  var storageRef: FIRStorageReference {
    return FIRStorage.storage().reference()
  }
  
  
  // 1  We create the User
  
  func signUp(_ email: String, fullname: String, password: String,imageData: Data!,complition: @escaping (_ error: Error?) -> Void) {
    
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
      
      if error == nil {
        
        self.setUserInfo(user, fullname: fullname, password: password, imageData: imageData)
        
      }else {
        print(error!.localizedDescription)
        
      }
      complition(error)
    })
    
  }
  
  // 2  Set User Info
  
  fileprivate func setUserInfo(_ user: FIRUser!, fullname: String, password: String,  imageData: Data!){
    
    //Create Path for the User Image
    let imagePath = "usersProfileImages/\(user.uid)/userPic.jpg"
    
    // Create image Reference
    
    let imageRef = storageRef.child(imagePath)
    
    // Create Metadata for the image
    
    let metaData = FIRStorageMetadata()
    metaData.contentType = "image/jpeg"
    
    // Save the user Image in the Firebase Storage File
    
    imageRef.put(imageData, metadata: metaData) { (metaData, error) in
      if error == nil {
        
        let changeRequest = user.profileChangeRequest()
        changeRequest.displayName = fullname
        changeRequest.photoURL = metaData!.downloadURL()
        changeRequest.commitChanges(completion: { (error) in
          
          if error == nil {
            
            self.saveInfo(user, fullname: fullname, password: password)
            
          }else{
            print(error!.localizedDescription)
            
          }
        })
        
      }else {
        print(error!.localizedDescription)
        
      }
    }
  }
  
  
  // 3  Saving the user Info in the database
  fileprivate func saveInfo(_ user: FIRUser!, fullname: String, password: String){
    
    // Create our user dictionary info\
    
    let userInfo = ["email": user.email!, "fullname": fullname,"profileImageUrl": String(describing: user.photoURL!)]
    
    // create user reference
    
    let userRef = databaseRef.child("Users").child(user.uid)
    
    // Save the user info in the Database
    
    userRef.setValue(userInfo)
    
  }
  
  // 4  Signing in the User
  func signIn(_ email: String, password: String, complition: @escaping (_ error: Error?) -> Void){
    
    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
      if error == nil {
        
        if let user = user {
          
          print("\(user.displayName!) has signed in succesfully!")
        }
      }else {
        
        print(error!.localizedDescription)
        
      }
      complition(error)
    })
  }
  

  // Reset Password
  func resetPassword(_ email: String,complition: @escaping (_ error: Error?) -> Void){
    FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: { (error) in
      if error == nil {
        print("An email with information on how to reset your password has been sent to you. thank You")
      }else {
        print(error!.localizedDescription)
        
      }
      complition(error)
    })
    
  }

}












