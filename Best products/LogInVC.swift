//
//  LogInVC.swift
//  Best products
//
//  Created by Ashot on 5/30/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit

class LogInVC: UIViewController {
  
  
  @IBOutlet var emailTF: HoshiTextField!
  
  @IBOutlet var passwordTF: HoshiTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
    self.hideKeyboardWhenTappedAround()
    
    
  }
  
  
  @IBAction func logInBtnTapped(_ sender: Any) {
  }
  

  
}
