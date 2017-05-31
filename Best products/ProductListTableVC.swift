//
//  ProductListTableVC.swift
//  Best products
//
//  Created by Ashot on 5/24/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit


class ProductListTableVC: UITableViewController {
  
  var products: [Product] = []
  var favoutitesProducts: [Product] = []
  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    

    
    products = Product.createProducts()
    
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return products.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    
//    if indexPath.row == 0 {
//      let topCell = tableView.dequeueReusableCell(withIdentifier: "topProductsCell", for: indexPath) as! TopProductsCell
//      topCell.favouritesProducts = favoutitesProducts
//      return topCell
//    }else if indexPath.row % 9 == 0 {
//      let topCell = tableView.dequeueReusableCell(withIdentifier: "topProductsCell", for: indexPath) as! TopProductsCell
//      topCell.favouritesProducts = favoutitesProducts
//      return topCell
//    }
    
    let product = products[indexPath.row]
    let productCell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
    productCell.product = product
    
    return productCell
    
  
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
//    if indexPath.row == 0 {
//      return 130.0
//    }else if indexPath.row % 9 == 0 {
//      return 130.0
//    }
    return 170.0
  }
  
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "toProductDetailVC", sender: indexPath)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier ==  "toProductDetailVC") {
      if let indexPath = tableView.indexPathForSelectedRow{
        let selectedRow = indexPath.row
        let productDetailVC = segue.destination as! ProductDetailVC
        productDetailVC.product = self.products[selectedRow]
      }
    }
  }
  

}










