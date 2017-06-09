//
//  Product.swift
//  Best products
//
//  Created by Ashot on 5/24/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class Product {
  
  var ref: FIRDatabaseReference?
  var key:String?
  var title:String?
  var description: String?
  var mainImageUrl: String?
  var otherImagesUrls:[String]?
  var price:Double?
  var previousPrice:Double?
  var averageRating:Double?
  var estimatedShipping:Double?
  var tax:Double?
  var newProduct:Bool?
  var hotProduct:Bool?
  var productOnSale:Bool?
  var comments: [Comment]?
  var onFavourites: Bool?
  var onBasket: Bool?
  
  init(snapshot: FIRDataSnapshot) {
    
    let dict = snapshot.value as? NSDictionary
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.title = dict?["title"] as? String
    self.description = dict?["description"] as? String
    self.mainImageUrl = dict?["mainImageUrl"] as? String
    self.otherImagesUrls = dict?["otherImagesUrls"] as? [String]
    self.price = dict?["price"] as? Double
    self.previousPrice = dict?["previousPrice"] as? Double
    self.averageRating = dict?["averageRating"] as? Double
    self.estimatedShipping = dict?["estimatedShipping"] as? Double
    self.tax = dict?["tax"] as? Double
    self.newProduct = dict?["newProduct"] as? Bool // change new W on data base
    self.hotProduct = dict?["hotProduct"] as? Bool
    self.productOnSale = dict?["productOnSale"] as? Bool
    
    let comments = snapshot.childSnapshot(forPath: "comments")
    
    if comments.childrenCount > 0 {
      var allComments = [Comment]()
      for comment in comments.children {
        let newComment = Comment(snapshot: comment as! FIRDataSnapshot)
        allComments.append(newComment)
      }
      self.comments = allComments
    }
  }
  
}





