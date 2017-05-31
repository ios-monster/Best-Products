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

class SignUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  
  let databaseRef = FIRDatabase.database().reference()
  let storageRef = FIRStorage.storage().reference()
  
  
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
      self.view.frame.origin.y -= 30
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0{
      self.view.frame.origin.y += 30
    }
  }
  
  var profileUrl:String?
  
  @IBAction func signUpBtnTapped(_ sender: Any) {
    
    
    FIRAuth.auth()?.createUser(withEmail: emailTF.text!, password: passwordTF.text!, completion: { (user, error) in
      let dict = ["email" : self.emailTF.text!, "fullname": self.fullnameTF.text!, "profileUrl": self.profileUrl]
      if error == nil {
        self.dismiss(animated: true, completion: nil)
        print("user created")
        
        setToDatabase(user: user!, dict: dict as [String : AnyObject])
      }
      
    })
    
    
    func setToDatabase(user:FIRUser, dict:[String:AnyObject]) {
      databaseRef.child("users").child(user.uid).setValue(dict)
      
      var data = NSData()
      data = UIImageJPEGRepresentation(profileImage.image!, 0.6)! as NSData
      // set upload path
      let filePath = "\(FIRAuth.auth()!.currentUser!.uid)/\("profileImage")"
      let metaData = FIRStorageMetadata()
      metaData.contentType = "image/jpg"
      self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
        if let error = error {
          print(error.localizedDescription)
          return
        }else{
          //store downloadURL
          let downloadURL = metaData!.downloadURL()!.absoluteString
          self.profileUrl = downloadURL
        }
      }
    }
    
  }
  
  
  
  
  
  
  
  
  @IBAction func cancelAction(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
    
  }
  
  

  
  
  
}
