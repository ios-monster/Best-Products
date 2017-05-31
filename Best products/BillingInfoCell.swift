//
//  BillingInfoCell.swift
//  Best products
//
//  Created by Ashot on 5/27/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import SCLAlertView

class BillingInfoCell: UITableViewCell {
  
  
}

class BillingTFCell: UITableViewCell {
  
  @IBOutlet var emailTF: LeftPaddedTextField!
  @IBOutlet var cardNumberTF: LeftPaddedTextField!
  @IBOutlet var expirationDateTF: LeftPaddedTextField!
  @IBOutlet var cvvTF: LeftPaddedTextField!
  
  func setTFUI() {
    self.emailTF.setBorderUI()
    self.cardNumberTF.setBorderUI()
    self.expirationDateTF.setBorderUI()
    self.cvvTF.setBorderUI()
  }
}

protocol SubmitOrderDidTappedDelegate {
  func gotoMyProfileVC()
}

class BillingTotalCell: UITableViewCell {
  
  var delegate:SubmitOrderDidTappedDelegate?
  
  @IBOutlet var subtotal: UILabel!
  @IBOutlet var shipping: UILabel!
  @IBOutlet var tax: UILabel!
  @IBOutlet var total: UILabel!
  
  
  @IBAction func SubmitOrder(_ sender: Any) {
    
    let alertViewResponder = SCLAlertView().showTitle(
      "Success", // Title of view
      subTitle: "We will inform you when products will come.", // String of view
      duration: 0.0, // Duration to show before closing automatically, default: 0.0
      completeText: "Continue shopping", // Optional button value, default: ""
      style: .success, // Styles - see below.
      colorStyle: 0x50B28F,
      colorTextButton: 0xFFFFFF
    )
    alertViewResponder.setDismissBlock {
      self.delegate?.gotoMyProfileVC()
    }
  }
  
}









