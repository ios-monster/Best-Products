//
//  NewCommentVC.swift
//  Best products
//
//  Created by Ashot on 5/25/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import Cosmos

protocol NewCommentDelegate {
  func addNewComment(comment:Comment)
}

class NewCommentVC: UIViewController {
  
  var comments: [Comment]?
  
  @IBOutlet weak var commentTextField: UITextField!
  @IBOutlet weak var ratingView: CosmosView!
  
  var delegate:NewCommentDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.ratingView.settings.fillMode = .full
    
    self.hideKeyboardWhenTappedAround()

  }
  
  
  @IBAction func cancelTapped(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  
  @IBAction func addNewComment(_ sender: Any) {
    
    if (self.commentTextField.text?.isEmpty == false) {
      
      let text = commentTextField.text
      let rating = self.ratingView.rating
      let toProduct = comments?.first?.toProduct
      let user = User(uid: "afsf", fullname: "antuan", ref: "adsfa", key: "adsfa", imageUrl: nil, favouritesProducts: nil)
      let comment = Comment(uid: "asdfasdf", text: text!, toProduct: toProduct, addedByUser: user, dateAdded: Date(), rating: rating)
      delegate?.addNewComment(comment: comment)
    }
    dismiss(animated: true, completion: nil)
    
  }
  
  
//  func dismissKeyboard() {
//    view.endEditing(true)
//  }
//  
}








