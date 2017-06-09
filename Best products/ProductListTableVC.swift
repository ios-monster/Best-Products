//
//  ProductListTableVC.swift
//  Best products
//
//  Created by Ashot on 5/24/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProductListTableVC: UITableViewController {
  
  let networkService = NetworkService()
  let currentUser = FIRAuth.auth()?.currentUser?.uid
  
  var products: [Product] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Download products from database
    downloadProducts()
    
    // Navigation appearence
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    updateUI()
    
  }
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return products.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let product = products[indexPath.row]
    let productCell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductCell
    productCell.product = product
    
    
    return productCell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
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
  
  
  private func downloadProducts() {
    self.networkService.databaseRef.child("Products").observeSingleEvent(of: .value, with: { (snapshot) in
      var allProducts = [Product]()
      for product in snapshot.children {
        let product = Product(snapshot: product as! FIRDataSnapshot)
        allProducts.append(product)
      }
      self.products = allProducts
      let tabbar = self.tabBarController as! CustomTabBarController
      tabbar.products = self.products
      
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    })
  }
  
  
  private func updateUI() {
    
    FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
      if user != nil {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }else {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    })
  }
}








