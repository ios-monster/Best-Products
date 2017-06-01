//
//  SignUpVC.swift
//  Best products
//
//  Created by Ashot on 5/30/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SCLAlertView


class SignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  let networkService = NetworkingService()
  
  @IBOutlet var profileImage: UIImageView!
  @IBOutlet var fullnameTF: HoshiTextField!
  @IBOutlet var emailTF: HoshiTextField!
  @IBOutlet var passwordTF: HoshiTextField!
  
  let imagePicker = UIImagePickerController()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    
    
    
    
    
    imagePicker.delegate = self
    profileImage.layer.cornerRadius = profileImage.frame.height / 2
    let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
    profileImage.isUserInteractionEnabled = true
    profileImage.addGestureRecognizer(imageTap)
    
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    self.hideKeyboardWhenTappedAround()
    NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(SignUpVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }
  
  func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
    
    imagePicker.allowsEditing = false
    imagePicker.sourceType = .photoLibrary
    
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
      profileImage.image = pickedImage
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  // Move view up when keyboard will show
  func keyboardWillShow(notification: NSNotification) {
    if self.view.frame.origin.y == 0{
      self.view.frame.origin.y -= 40
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0{
      self.view.frame.origin.y += 40
    }
  }
  
  var profileUrl:String?
  
  @IBAction func signUpBtnTapped(_ sender: Any) {
    
    guard let fullname = fullnameTF.text?.condenseWhitespace() else {
      return
    }
    guard let email = emailTF.text?.condenseWhitespace() else {
      return
    }
    guard let password = passwordTF.text  else {
      return
    }
    
    if fullnameTF.text?.isEmpty == false && emailTF.text?.isEmpty == false && passwordTF.text?.isEmpty == false {
      // text fields are not empty
      
      guard let imageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.8) else {return} // Cant create data from iamge
      
      networkService.signUp(email, fullname: fullname, password: password, imageData: imageData, complition: { (error) in
        // have got some error
        if error != nil {
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
        } else {
          
            self.view.endEditing(true)
            let alertViewResponder: SCLAlertViewResponder = SCLAlertView().showSuccess("User created", subTitle: "Now you can add comments and rate products.")
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
  
  
  @IBAction func cancelAction(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
    
  }
  
}











