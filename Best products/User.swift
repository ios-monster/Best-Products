//
//  User.swift
//  Best products
//
//  Created by Ashot on 6/7/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class User {
  
  var ref: FIRDatabaseReference?
  var key: String?
  var fullname:String?
  var email:String?
  var profileImageUrl:String?
  
  var commentsPosted:[Comment]?
  var productsOnFavourites:Int?
  var productsOnBasket:Int?
  
  init(snapshot:FIRDataSnapshot) {
    
    let dict = snapshot.value as? NSDictionary
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.fullname = dict?["fullname"] as? String
    self.email = dict?["email"] as? String
    self.profileImageUrl = dict?["profileImageUrl"] as? String
    
    let comments = snapshot.childSnapshot(forPath: "comments")
    
    if comments.childrenCount > 0 {
      var allComments = [Comment]()
      for comment in comments.children {
        let newComment = Comment(snapshot: comment as! FIRDataSnapshot)
        allComments.append(newComment)
      }
      self.commentsPosted = allComments
    }
    
    let favourites = snapshot.childSnapshot(forPath: "favouritesProducts")
    self.productsOnFavourites = Int(favourites.childrenCount)
    
    let productsOnBasket = snapshot.childSnapshot(forPath: "productsOnBasket")
    self.productsOnBasket = Int(productsOnBasket.childrenCount)
  }
  
}




