//
//  CustomTabBarController.swift
//  Best products
//
//  Created by Ashot on 6/4/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseDatabase


class CustomTabBarController: UITabBarController {
  
  var products: [Product] = []
  let networkService = NetworkService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    

  }
}
