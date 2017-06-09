
//  CheckoutTableVC.swift
//  Best products
//
//  Created by Ashot on 5/27/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import SCLAlertView

class CheckoutTableVC: UITableViewController {
  
  
  var products = [Product]()
  var productsOnBasket = [Product]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tabbar = self.tabBarController as! CustomTabBarController
    self.products = tabbar.products
    
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
    self.tableView.register(UINib(nibName: "NoCheckoutTableViewCell", bundle: nil), forCellReuseIdentifier: "noCheckoutCell")
    
  }
  
  // MARK: - Table view data source
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    checkForProductsToCheckout()
    
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    
    if productsOnBasket.count > 0 {
      return productsOnBasket.count  + 2
    }
    return 1
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if productsOnBasket.count > 0 {
      
      if indexPath.row == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCountCell", for: indexPath) as! ItemsCountCell
        
        cell.itemsCount.text = "\(productsOnBasket.count) Products"
        return cell
      }else if indexPath.row == productsOnBasket.count + 1 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutTotalCell", for: indexPath) as! CheckoutTotalCell
        cell.subtotal.text = String("$ \(getSubtotal())")
        cell.shipping.text = String("$ \(getShipping())")
        cell.tax.text = String("$ \(getTax())")
        cell.total.text = String("$ \(getTotal())")
        return cell
        
      }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkoutProductCell", for: indexPath) as! CheckoutProductCell
        //      cell.delegate = self
        cell.product = productsOnBasket[indexPath.row - 1]
        cell.delegate = self
        return cell
      }
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "noCheckoutCell", for: indexPath)
    return cell
    
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if productsOnBasket.count > 0 {
      
      if indexPath.row == 0 {
        return 40.0
        
      }else if indexPath.row == productsOnBasket.count + 1 {
        return 255.0
      }
      return 130.0
    }
    
    return 230
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toBillingInfoVC" {
      let billingInfoTableVC = segue.destination as! BillingInfoTableVC
      billingInfoTableVC.subTotal = getSubtotal()
      billingInfoTableVC.shipping = getShipping()
      billingInfoTableVC.tax = getTax()
      billingInfoTableVC.total = getTotal()
    }
  }
  
  fileprivate func checkForProductsToCheckout() {
    var allCheckoutProducts = [Product]()
    for product in products {
      if product.onBasket == true {
        allCheckoutProducts.append(product)
      }
    }
    self.productsOnBasket = allCheckoutProducts
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  fileprivate func getSubtotal() -> Double {
    var subtotal:Double = 0
    for product in productsOnBasket {
      subtotal += product.price!
    }
    return subtotal
  }
  fileprivate func getShipping() -> Double {
    var shipping:Double = 0
    for product in productsOnBasket {
      if product.estimatedShipping != 0 {
        shipping += product.estimatedShipping!
      }
    }
    return shipping
  }
  
  fileprivate func getTax() -> Double {
    var tax:Double = 0
    for product in productsOnBasket {
      if product.tax != 0 {
        tax += product.tax!
      }
    }
    return tax
  }
  fileprivate func getTotal() -> Double {
    let subtotal = getSubtotal()
    let tax = getTax()
    let shipping = getShipping()
    return subtotal + tax + shipping
  }
}

extension CheckoutTableVC:  DeleteProductFromBasket {
  func deleteProduct(cell: UITableViewCell) {
    guard let index = tableView.indexPath(for: cell)?.row else { return }
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    self.productsOnBasket.remove(at: index - 1)
    self.tableView.deselectRow(at: indexPath, animated: true)
    self.tableView.reloadData()
  }
}




















