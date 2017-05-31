
//  CheckoutTableVC.swift
//  Best products
//
//  Created by Ashot on 5/27/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import SCLAlertView

class CheckoutTableVC: UITableViewController {
  
  
  var productsToCheckout:[Product]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    self.productsToCheckout = Product.createProducts()
    
  }
  
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    
    if productsToCheckout != nil {
      return (productsToCheckout?.count)! + 2
    } else {
      return 1
    }
    
    
  }
  
  
  func getTotalInt() -> Double {
    var total: Double = 0.0
    for product in self.productsToCheckout! {
      total += product.price!
    }
    return total
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
    guard productsToCheckout != nil else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCountCell", for: indexPath) as! ItemsCountCell
      cell.itemsCount.text = "\(0) Products"
      return cell
    }
    
    
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCountCell", for: indexPath) as! ItemsCountCell
      
      if let count = productsToCheckout?.count {
        cell.itemsCount.text = "\(count) Products"
      }
      return cell
    }else if indexPath.row == (productsToCheckout?.count)! + 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutTotalCell", for: indexPath) as! CheckoutTotalCell
      cell.total.text = String("$ \(getTotalInt())")
      return cell
      
    }else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutProductCell", for: indexPath) as! CheckoutProductCell
      cell.delegate = self
      cell.product = productsToCheckout?[indexPath.row - 1]
      return cell
    }
    
    
    
    
    //        if indexPath.row == 0 {
    //
    //          let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCountCell", for: indexPath) as! ItemsCountCell
    //          cell.itemsCount.text = "\(0) Products"
    //
    //          return cell
    //
    //        }else if indexPath.row == 1 {
    //
    //          let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutTotalCell", for: indexPath) as! CheckoutTotalCell
    //
    //          return cell
    //
    //      }
    //
    //      return UITableViewCell()
  }
  
  
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.row == 0 {
      return 40.0
      
    }else if indexPath.row == (productsToCheckout?.count)! + 1 {
      return 255.0
    }
    
    return 130.0
  }
}


extension CheckoutTableVC:  DeleteProductCellDelegate {
  
  func deleteThisCell(cell: UITableViewCell) {
    
    // Info that cell is deleted
    let indexPath = tableView.indexPath(for: cell)
    productsToCheckout?.remove(at: (indexPath?.row)! - 1)
    tableView.deleteRows(at: [indexPath!], with: .fade)
    tableView.reloadData()
    
    
//    guard let title = productsToCheckout?[(indexPath?.row)! - 1].title else { return }
//
////     SCLAlertView().showTitle(
////    "Product deleted", // Title of view
////    subTitle: "\(title) deleted", // String of view
////    duration: 0.0, // Duration to show before closing automatically, default: 0.0
////    completeText: "Done", // Optional button value, default: ""
////    style: .info, // Styles - see below.
////    colorStyle: 0xA429FF,
////    colorTextButton: 0xFFFFFF
////)
//
//     let appearance = SCLAlertView.SCLAppearance(
//
//      kTitleFont: UIFont(name: "HelveticaNeue", size: 14)!,
//      kTextFont: UIFont(name: "HelveticaNeue", size: 12)!,
//      kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
//      showCloseButton: true,
//      showCircularIcon: true
//    )
//
//    let alert = SCLAlertView(appearance: appearance)
//    alert.showInfo("Product deleted", subTitle:"\(title) deleted")



    
  }

  
}




















