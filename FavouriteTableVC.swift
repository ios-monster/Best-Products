//
//  FavouriteTableVC.swift
//  Best products
//
//  Created by Ashot on 5/26/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit

class FavouriteTableVC: UITableViewController {
  
  var favoutitesProducts: [Product] = []
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.favoutitesProducts = Product.createProducts()
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    
    return favoutitesProducts.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let favouriteProduct = favoutitesProducts[indexPath.row]
    let favouriteCell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteTableViewCell
    favouriteCell.product = favouriteProduct
    return favouriteCell
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
        productDetailVC.product = self.favoutitesProducts[selectedRow]
      }
    }
  }
  
}

