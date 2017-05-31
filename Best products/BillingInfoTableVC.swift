//
//  BillingInfoTableVC.swift
//  Best products
//
//  Created by Ashot on 5/27/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit


class BillingInfoTableVC: UITableViewController, UITextFieldDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.hideKeyboardWhenTappedAround()
    self.navigationController?.navigationBar.tintColor = UIColor.white
    
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == 0 {
      let billingCell = tableView.dequeueReusableCell(withIdentifier: "billingInfoCell", for: indexPath) as! BillingInfoCell
      return billingCell
    }else if indexPath.row == 1 {
      let billingTFCell = tableView.dequeueReusableCell(withIdentifier: "billingTFCell", for: indexPath) as! BillingTFCell
      billingTFCell.setTFUI()
      return billingTFCell
    } else if indexPath.row == 2 {
      let billingTotalCell = tableView.dequeueReusableCell(withIdentifier: "billingTotalCell", for: indexPath) as! BillingTotalCell
      billingTotalCell.delegate = self
      return billingTotalCell
    }
    return UITableViewCell()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.row == 0 {
      return 40.0
    }else if indexPath.row == 1 {
      return 338.0
    } else if indexPath.row == 2 {
      return 245.0
    }
    
    return 0.0
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return true
  }
  
}

extension BillingInfoTableVC: SubmitOrderDidTappedDelegate {
  
  func gotoMyProfileVC() {
    DispatchQueue.main.async {
    self.navigationController?.popToRootViewController(animated: false)
    }
    self.tabBarController?.selectedIndex = 0
  }
}






























