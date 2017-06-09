//
//  NewCommentVC.swift
//  Best products
//
//  Created by Ashot on 5/25/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView
import Cosmos


protocol NewCommentDelegate {
  func addNewComment(commentKey:String)
}

class NewCommentVC: UIViewController {
  
  var product: Product?
  var delegate: NewCommentDelegate?
  
  let networkService = NetworkService()

  
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var ratingView: CosmosView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.ratingView.settings.fillMode = .full
    self.hideKeyboardWhenTappedAround()

  }
  
  
  @IBAction func cancelTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func addNewComment(_ sender: Any) {
    
    let currentUser = FIRAuth.auth()?.currentUser?.uid
    
    if (self.commentTextField.text?.isEmpty == false) {
      
      let text = commentTextField.text!
      let rating = ratingView.rating
      let date = Date()
      let addedByUser = FIRAuth.auth()?.currentUser?.displayName!
      let toProduct = self.product?.key!
      let newComment = Comment(text: text, toProduct: toProduct!, addedByUser: addedByUser!, dateAdded: date, rating: rating)
      let uuid = UUID().uuidString
      
      networkService.databaseRef.child("Users").child(currentUser!).child("comments").child(uuid).setValue(newComment.toAnyObject())
      networkService.databaseRef.child("Products").child((self.product?.key)!).child("comments").child(uuid).setValue(newComment.toAnyObject())
      delegate?.addNewComment(commentKey: uuid)
      dismiss(animated: true, completion: nil)
      
    }else {
      // text field is empty 
      let _ : SCLAlertViewResponder = SCLAlertView().showInfo("Text field is empty", subTitle: "")
    }
}

}






