//
//  ResetPasswordVC.swift
//  Best products
//
//  Created by Ashot on 5/30/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {
  
  
  @IBOutlet var emailTF: HoshiTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
    self.hideKeyboardWhenTappedAround()

  }

  @IBAction func resetBtnTapped(_ sender: Any) {
  }

  

  
}



