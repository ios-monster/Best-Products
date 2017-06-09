//
//  ProductCell.swift
//  Best products
//
//  Created by Ashot on 5/24/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import SCLAlertView

class ProductCell: UITableViewCell {
  
  let networkService = NetworkService()
  
  var currentUser:String {
    get{
      return (FIRAuth.auth()?.currentUser?.uid)!
    }
  }
  
  var product:Product? {
    didSet {
      updateUI()
    }
  }
  
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var productPreviousPrice: UILabel!
  @IBOutlet weak var productComments: UILabel!
  @IBOutlet weak var productAverageRating: UILabel!
  
  @IBOutlet weak var newProduct: UIView!
  @IBOutlet weak var hotProduct: UIView!
  @IBOutlet weak var productOnSale: UIView!
  
  @IBOutlet weak var heartBtn: DOFavoriteButton!
  
  @IBAction func addOnFavouritesTapped(_ sender: DOFavoriteButton!) {
    
    if FIRAuth.auth()?.currentUser == nil {
      
      // no user
      let _: SCLAlertViewResponder = SCLAlertView().showInfo("Need an account", subTitle: "To add to favourites you need to sign in")
    }else {
      // user signed in
      
      if self.product?.onFavourites == true {
        // on favourites yet
        heartBtn.deselect()
        self.product?.onFavourites = false
        updateHeartBtn()
        self.networkService.databaseRef.child("Users").child("\(String(describing: currentUser))").child("favouritesProducts").child((self.product?.key)!).removeValue(completionBlock: { (error, ref) in
          if error == nil {
            print("removed product from user database")
          }
        })
        
      }else {
        
        // product not on favourites
        
        self.product?.onFavourites = true
        heartBtn.select()
        updateHeartBtn()
        // adding product to user favourites on database
        if let productRef = self.product?.ref {
          self.networkService.databaseRef.child("Users").child("\(String(describing: currentUser))").child("favouritesProducts").child((self.product?.key)!).setValue(["productRef": String(describing: productRef)])
        }
      }
    }
  }
  
  func updateCommentsCount() {
    if let commentsCount = product?.comments?.count {
      self.productComments.text = String(commentsCount)
    }
  }
  
  
  func updateUI() {
    updateHeartBtn()
    checkUserFavouritesAndProductsOnBasket()
    
    if let mainImageUrl = product?.mainImageUrl {
      let url = URL(string: mainImageUrl)!
      productImage.kf.indicatorType = .activity
      productImage.kf.setImage(with: url)
    }
    
    if let price = product?.price {
      self.productPrice.text = String(describing: "$ \(price)")
    }
    
    if product?.previousPrice != 0.0 {
      if let prevousPrice = product?.previousPrice {
        // Adding struck through to string
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(describing: "$ \(prevousPrice)"))
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value:2, range: NSMakeRange(0, attributeString.length ))
        
        self.productPreviousPrice.attributedText = attributeString
      }
    } else {
      self.productPreviousPrice.text = ""
    }
    
    
    if let rating = product?.averageRating {
      self.productAverageRating.text = String(describing: rating)
    }
    
    
    if let commentsCount = product?.comments?.count {
      self.productComments.text = String(commentsCount)
    }
    
    self.productTitle.text = product?.title
    
    self.newProduct.isHidden = !(product?.newProduct)!
    self.hotProduct.isHidden = !(product?.hotProduct)!
    self.productOnSale.isHidden = !(product?.productOnSale)!
    
  }
  
  private func updateHeartBtn() {
    if product?.onFavourites == true{
      self.heartBtn?.select()
    }else {
      self.heartBtn?.deselect()
    }
  }
  
  private func checkUserFavouritesAndProductsOnBasket() {
    
    if FIRAuth.auth()?.currentUser != nil {
      // User loged in
      
      networkService.databaseRef.child("Users").child("\(String(describing: currentUser))").observeSingleEvent(of: .value, with: { (snapshot) in
        
        if snapshot.hasChild("favouritesProducts") {
          
          self.networkService.databaseRef.child("Users").child("\(String(describing: self.currentUser))").child("favouritesProducts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild((self.product?.key)!) {
              // product already on favourites
              self.product?.onFavourites = true
              self.updateHeartBtn()
            }else {
              // product not on favourites yet
              self.product?.onFavourites = false
              self.updateHeartBtn()

            }
          })
        }
        
        if snapshot.hasChild("productsOnBasket") {
          
          self.networkService.databaseRef.child("Users").child("\(String(describing: self.currentUser))").child("productsOnBasket").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild((self.product?.key)!) {
              // product already on favourites
              self.product?.onBasket = true
            }else {
              // product not on favourites yet
              self.product?.onBasket = false
            }
          })
        }
      })
    }else {
      product?.onFavourites = false
      product?.onBasket = false
      updateHeartBtn()
    }
  }
}



