//
//  FavouriteTableViewCell.swift
//  Best products
//
//  Created by Ashot on 5/26/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

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
  
  
  @IBAction func addOnFavouritesTapped(_ sender: Any) {
    
  }
  
  
  
  func updateUI() {
    
    if let mainImage = product?.productMainImage {
      self.productImage.image = mainImage
    }
    
    if let price = product?.price {
      self.productPrice.text = String(describing: "$ \(price)")
    }
    
    
    if product?.previousPrice != nil {
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
    self.productOnSale.isHidden = !(product?.saleProduct)!
  }
}














