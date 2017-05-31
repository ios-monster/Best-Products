//
//  CheckoutTableViewCell.swift
//  Best products
//
//  Created by Ashot on 5/27/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit


protocol DeleteProductCellDelegate{
  
  func deleteThisCell(cell: UITableViewCell)
}


class CheckoutProductCell: UITableViewCell {
  
  
  var delegate:DeleteProductCellDelegate?
  
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
    
    delegate?.deleteThisCell(cell: self as UITableViewCell)
    
  }
  
  
  
  private func updateUI() {
   
    if let mainImage = product?.productMainImage {
      self.productImage.image = mainImage
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

