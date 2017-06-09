//
//  FavouriteTableViewCell.swift
//  Best products
//
//  Created by Ashot on 5/26/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol DeleteFromFavouritesDelegate{
  func deleteProduct(cell:UITableViewCell)
}

class FavouriteTableViewCell: UITableViewCell {
  
  var currentUser:String {
    get{
      return (FIRAuth.auth()?.currentUser?.uid)!
    }
  }
  let networkService = NetworkService()
  var delegate:DeleteFromFavouritesDelegate?
  
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
  
  @IBOutlet weak var heartBtn: UIButton!
  
  
  @IBAction func deleteFromFavourites(_ sender: Any) {
    
    self.product?.onFavourites = false
    delegate?.deleteProduct(cell: self)

    self.networkService.databaseRef.child("Users").child("\(String(describing: currentUser))").child("favouritesProducts").child((self.product?.key)!).removeValue(completionBlock: { (error, ref) in
      if error == nil {
        print("removed product from user database")
      }
    })
  }
  
  func updateUI() {
    
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
}














