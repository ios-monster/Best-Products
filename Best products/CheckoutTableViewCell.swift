//
//  CheckoutTableViewCell.swift
//  Best products
//
//  Created by Ashot on 5/27/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


protocol DeleteProductFromBasket{
  func deleteProduct(cell:UITableViewCell)
}

class CheckoutProductCell: UITableViewCell {
  
  var currentUser:String {
    get{
      return (FIRAuth.auth()?.currentUser?.uid)!
    }
  }
  let networkService = NetworkService()
  
  var delegate:DeleteProductFromBasket?
  
  var product:Product? {
    didSet{
      updateUI()
    }
  }
  
  
  @IBOutlet weak var productImage: UIImageView!
  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet var bgView: UIView!
  
  
  @IBAction func deleteProductTapped(_ sender: Any) {
    
    self.product?.onBasket = false
    delegate?.deleteProduct(cell: self)
    self.networkService.databaseRef.child("Users").child("\(String(describing: currentUser))").child("productsOnBasket").child((self.product?.key)!).removeValue(completionBlock: { (error, ref) in
      if error == nil {
        print("removed product from user database")
      }
    })
    
    
  }
  
  private func updateUI() {
   
    if let mainImageUrl = product?.mainImageUrl {
      let url = URL(string: mainImageUrl)!
      productImage.kf.indicatorType = .activity
      productImage.kf.setImage(with: url)
    }

    
    if let price = product?.price {
      self.productPrice.text = String(describing: "$ \(price)")
    }
    
    self.productTitle.text = product?.title

  }
}


class ItemsCountCell: UITableViewCell {
  
  @IBOutlet weak var itemsCount: UILabel!
  
}


class CheckoutTotalCell: UITableViewCell {
  
  @IBOutlet weak var subtotal: UILabel!
  @IBOutlet weak var shipping: UILabel!
  @IBOutlet weak var tax: UILabel!
  @IBOutlet weak var total: UILabel!
  

}

