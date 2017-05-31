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
import UIKit

class Product {
  
  var uid:String?
  var title:String?
  var description:String?
  var images:[UIImage]?
  var productMainImage:UIImage?
  var price:Double?
  var previousPrice:Double?
  var averageRating:Double?
  var onFavourites: Bool? = false
  var estimatedShipping:Double?
  var tax:Double?
  
  var comments:[Comment]?
  
  var newProduct:Bool?
  var hotProduct:Bool?
  var saleProduct:Bool?
  
  init(uid:String, title:String, desciption:String, images:[UIImage], productMainImage:UIImage, price:Double, preciousPrice:Double?,comments:[Comment]?, avareageRating:Double, newProduct:Bool,hotProduct:Bool, saleProduct:Bool){
    
    self.uid = uid
    self.title = title
    self.description = desciption
    self.images = images
    self.price = price
    self.previousPrice = preciousPrice
    self.averageRating = avareageRating
    self.newProduct = newProduct
    self.hotProduct = hotProduct
    self.saleProduct = saleProduct
    self.productMainImage = productMainImage
    self.comments = comments
    
  }
  
  static func createProducts() -> [Product] {
    
    var products:[Product] = []
    
    let ashtonm = User(uid: "dfs", fullname: "ashtonm", ref: "asfsaf", key: "asfasf", imageUrl: "asfasf", favouritesProducts: nil)

    
    let comments: [Comment] = [Comment(uid: "12ASF", text: "Very cool iphone, take them without thinking", toProduct: nil, addedByUser: ashtonm , dateAdded: Date(), rating: 4.8),Comment(uid: "12ASF", text: "Not bad, but you can take better mac for this price, Very cool iphone, take them without thinking", toProduct: nil, addedByUser: ashtonm , dateAdded: Date(), rating: 4.8)]
 
    let p1 = Product(uid: "afdad", title: "Iphone 7s 64 gb space grey", desciption: "new iphone with all functions", images: [UIImage(named:"iMac")!, UIImage(named:"ipadPro")!, UIImage(named:"iwatch")!], productMainImage: UIImage(named:"iphone7")!, price: 190.0, preciousPrice: 1200.0, comments: comments, avareageRating: 4.8, newProduct: false, hotProduct: true, saleProduct: false)
    
    let p2 = Product(uid: "afdad", title: "Mac book 2016  256 ssd space grey", desciption: "Mac book with all functions", images: [UIImage(named:"iMac")!, UIImage(named:"ipadPro")!, UIImage(named:"iphone7")!], productMainImage: UIImage(named:"iphone7")!, price: 5000.0, preciousPrice: nil, comments: comments, avareageRating: 2.8, newProduct: true, hotProduct: true, saleProduct: false)
    
    let p3 = Product(uid: "afdad", title: "Ipad pro gold  128 gb", desciption: "Ipad pro gold with all functions", images: [UIImage(named:"iMac")!, UIImage(named:"ipadPro")!, UIImage(named:"iphone7")!], productMainImage:UIImage(named:"iphone7")!, price: 890.0, preciousPrice: 400.0, comments: comments, avareageRating: 1.8, newProduct: true, hotProduct: false, saleProduct: true)
    
    let p4 = Product(uid: "afdad", title: "Iphone 7s 64 gb space grey", desciption: "new iphone with all functions", images: [UIImage(named:"iMac")!, UIImage(named:"ipadPro")!, UIImage(named:"iphone7")!], productMainImage: UIImage(named:"ipadPro")!, price: 860.0, preciousPrice: nil, comments: comments, avareageRating: 3.8, newProduct: true, hotProduct: true, saleProduct: true)
    
    let p5 = Product(uid: "afdad", title: "Mac book 2016  256 ssd space grey", desciption: "Mac book with all functions", images: [UIImage(named:"iMac")!, UIImage(named:"ipadPro")!, UIImage(named:"iphone7")!], productMainImage: UIImage(named:"iMac")!, price: 8920.0, preciousPrice: 1200.0, comments: comments, avareageRating: 3.0, newProduct: false, hotProduct: true, saleProduct: false)
    
    let p6 = Product(uid: "afdad", title: "Ipad pro gold  128 gb", desciption: "Ipad pro gold with all functions", images: [UIImage(named:"iMac")!, UIImage(named:"ipadPro")!, UIImage(named:"iphone7")!], productMainImage: UIImage(named:"ipadPro")!, price: 890.0, preciousPrice: 13400.0, comments: comments, avareageRating: 1.8, newProduct: true, hotProduct: false, saleProduct: false)
    
    
    products.append(p1)
    products.append(p2)
    products.append(p3)
    products.append(p4)
    products.append(p5)
    products.append(p6)

    return products
  }
  
}

class User {
  
  var uid:String?
  var ref: String?
  var key:String?
  var fullname:String?
  var profielImage:String?
  var favouritesProducts:[Product]?
  
  init(uid:String, fullname:String, ref:String, key:String, imageUrl:String?, favouritesProducts:[Product]?) {
    self.uid = uid
    self.ref = ref
    self.key = key
    self.fullname = fullname
    self.profielImage = imageUrl
    self.favouritesProducts = favouritesProducts
  }
  

}


class Comment {
  var uid:String?
  var text:String?
  var toProduct:Product?
  var addedByUser:User?
  var dateAdded: Date?
  var rating:Double?
  
  
  init(uid:String, text:String, toProduct:Product?, addedByUser:User, dateAdded:Date, rating: Double) {
    
    self.uid = uid
    self.text = text
    self.toProduct = toProduct
    self.addedByUser = addedByUser
    self.dateAdded = dateAdded
    self.rating = rating
  }
  
  
}


struct BUser {
  
  var ref: FIRDatabaseReference?
  var key: String?
  var fullname:String?
  var email:String?
  var profileImageUrl:String?
  
  //  var commentsPosted:[Comment]?
  //  var favouritesProducts:[Product]?
  //  var productsOnBasket:[Product]?
  
//  init(ref: FIRDatabaseReference?, key: String, fullname: String, email:String, profileImageUrl:String?) {
//    self.ref = ref
//    self.key = key
//    self.fullname = fullname
//    self.email = email
//    self.profileImageUrl = profileImageUrl
//  }
//  
  init(snapshot:FIRDataSnapshot) {
    let dict = snapshot.value as? NSDictionary
    
    self.ref = snapshot.ref
    self.key = snapshot.key
    self.fullname = dict?["fullname"] as? String
    self.email = dict?["email"] as? String
    self.profileImageUrl = dict?["profileImageUrl"] as? String
}

  
}














