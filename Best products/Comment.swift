//
//  Comment.swift
//  Best products
//
//  Created by Ashot on 6/7/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class Comment {
  var key:String?
  var ref: FIRDatabaseReference?
  var text:String?
  var toProduct:String?
  var addedByUser:String?
  var dateAdded: Date?
  var rating:Double?
  
  init(text:String,toProduct:String,addedByUser: String,dateAdded:Date, rating:Double ) {
    self.text = text
    self.toProduct = toProduct
    self.addedByUser = addedByUser
    self.dateAdded = dateAdded
    self.rating = rating
  }
  
  init(snapshot:FIRDataSnapshot) {
    
    let dict = snapshot.value as? NSDictionary
    
    self.text = dict?["text"] as? String
    self.toProduct = dict?["toProduct"] as? String
    self.addedByUser = dict?["addedByUser"] as? String
    self.rating = dict?["rating"] as? Double
    self.ref = snapshot.ref
    self.key = snapshot.key
    
    // Date
    let dateString = dict?["dateAdded"] as? String
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yy"
    self.dateAdded = formatter.date(from: dateString!)
    
  }
  
  func toAnyObject() -> [String:Any] {
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-YY"
    
    let stringFromDate = formatter.string(from: dateAdded!)
    return ["text":text!, "toProduct":toProduct!,"addedByUser":addedByUser!, "dateAdded":stringFromDate, "rating":rating!]
  }
  
}
