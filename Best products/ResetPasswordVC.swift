//
//  ResetPasswordVC.swift
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


class ResetPasswordVC: UIViewController {
  
  let networkService = NetworkService()
  
  @IBOutlet var emailTF: HoshiTextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
    self.hideKeyboardWhenTappedAround()
    
  }
  
  @IBAction func resetBtnTapped(_ sender: Any) {
    
    guard let email = emailTF.text?.condenseWhitespace() else {return }
    
    if emailTF.text?.isEmpty == false  {
      // text field is not empty
      
      networkService.resetPassword(email, complition: { (error) in
        
        if error != nil {
          // have got some error
          if let errCode = FIRAuthErrorCode(rawValue: (error?._code)!) {
            switch errCode {
            case .errorCodeInvalidEmail:
              let _ : SCLAlertViewResponder = SCLAlertView().showError("invalid email", subTitle: "")
            case .errorCodeUserNotFound:
              let _ : SCLAlertViewResponder = SCLAlertView().showError("User not found", subTitle: "")
            default: break
            }
          }
        }else {
          // no errors
          let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("Success", subTitle: "Reset info has been sent to your email")
          alertViewResponder.setDismissBlock {
            self.dismiss(animated: true, completion: nil)
          }
        }
      })
    }else {
      // text field is empty
      let _ : SCLAlertViewResponder = SCLAlertView().showInfo("Text fields are empty", subTitle: "")
    }
  }
}



