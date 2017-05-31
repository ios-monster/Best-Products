//
//  LogInVC.swift
//  Best products
//
//  Created by Ashot on 5/30/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import SCLAlertView
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


class LogInVC: UIViewController {
  
  let networkService = NetworkingService()
  
  @IBOutlet var emailTF: HoshiTextField!
  
  @IBOutlet var passwordTF: HoshiTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
    self.hideKeyboardWhenTappedAround()
    
  }
  
  @IBAction func logInBtnTapped(_ sender: Any) {
    guard let email = emailTF.text?.condenseWhitespace() else {
      return
    }
    guard let password = passwordTF.text  else {
      return
    }
    
    if emailTF.text?.isEmpty == false && passwordTF.text?.isEmpty == false {
      // text fields are not empty
      
      networkService.signIn(email, password: password, complition: { (error) in
        
        if error != nil {
          // have got some error
          if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
            switch errCode {
            case .errorCodeEmailAlreadyInUse:
              print("email already in use")
              let _ : SCLAlertViewResponder = SCLAlertView().showError("email already in use", subTitle: "")
            case .errorCodeInvalidEmail:
              print("invalid email")
              let _ : SCLAlertViewResponder = SCLAlertView().showError("invalid email", subTitle: "")
            case .errorCodeWrongPassword:
              print("wrong password")
              let _ : SCLAlertViewResponder = SCLAlertView().showError("wrong password", subTitle: "")
            default: break
            }
          }
        }else {
          // no errors
          
          self.view.endEditing(true)
          guard let currentUser = FIRAuth.auth()?.currentUser?.displayName else {return}
          let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("Succes", subTitle:"\(currentUser) nice to see you again")
          alertViewResponder.setDismissBlock {
            self.dismiss(animated: true, completion: nil)
          }
        }
      })
      
    }else {
      // text fields are empty
      let _ : SCLAlertViewResponder = SCLAlertView().showInfo("Text fields are empty", subTitle: "")
    }
    
  }
  
  
}
























