//
//  Extensions.swift
//  Best products
//
//  Created by Ashot on 5/29/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import Foundation
import UIKit

class LeftPaddedTextField:UITextField {
  
  override func textRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
  }
  
  override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
  }
  
  override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
    return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width, height: bounds.height)
  }
  
  func setBorderUI() {
    self.layer.borderColor = UIColor.lightGray.cgColor
    self.layer.borderWidth = 1
  }
}


extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  func dismissKeyboard() {
    view.endEditing(true)
  }
}


extension String {
  func condenseWhitespace() -> String {
    return self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
      .filter { !$0.isEmpty }
      .joined(separator: " ")
  }
}
