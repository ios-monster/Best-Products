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

class ProductListTableVC: UITableViewController,BWWalkthroughViewControllerDelegate {
  
  let networkService = NetworkService()
  let currentUser = FIRAuth.auth()?.currentUser?.uid
    
  var products: [Product] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let userDefaults = UserDefaults.standard
    
    if !userDefaults.bool(forKey: "walkthroughPresented") {
      showWalkthrough()
      userDefaults.set(true, forKey: "walkthroughPresented")
      userDefaults.synchronize()
    }
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
  
  
  fileprivate func downloadProducts() {
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
  
 fileprivate func showWalkthrough() {
    
    // Get view controllers and build the walkthrough
    let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
    let walkthrough = stb.instantiateViewController(withIdentifier: "container") as! BWWalkthroughViewController
    let page_one = stb.instantiateViewController(withIdentifier: "page_1")
    let page_two = stb.instantiateViewController(withIdentifier: "page_2")
    let page_three = stb.instantiateViewController(withIdentifier: "page_3")
    
    // Attach the pages to the master
    walkthrough.delegate = self
    
    walkthrough.add(viewController:page_one)
    walkthrough.add(viewController:page_two)
    walkthrough.add(viewController:page_three)
    
    self.present(walkthrough, animated: true, completion: nil)
    
  }
  func walkthroughCloseButtonPressed() {
    self.dismiss(animated: true, completion: nil)
  }
  
  private func updateUI() {
    self.tableView.reloadData()
//    FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
//      if user != nil {
//        DispatchQueue.main.async {
//          self.tableView.reloadData()
//        }
//      }else {
//        DispatchQueue.main.async {
//          self.tableView.reloadData()
//        }
//      }
//    })
  }
}








