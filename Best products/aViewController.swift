//
//  aViewController.swift
//  Best products
//
//  Created by Ashot on 6/1/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage




class aViewController: UIViewController {
  var onFavourites:Bool = true
  
  @IBOutlet var doBtn: DOFavoriteButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if onFavourites {
      doBtn.select()
    }
  }
  
  @IBAction func doBtnAction(_ sender: DOFavoriteButton) {
    
    if sender.isSelected {
      sender.deselect()
    }else{
      sender.select()
    }
  }
}


