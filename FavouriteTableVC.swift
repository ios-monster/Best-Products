//
//  FavouriteTableVC.swift
//  Best products
//
//  Created by Ashot on 5/26/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class FavouriteTableVC: UITableViewController {
  
  var products = [Product]()
  var favourites = [Product]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tabbar = self.tabBarController as! CustomTabBarController
    self.products = tabbar.products
    
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    self.tableView.register(UINib(nibName: "NoFavouritesTableViewCell", bundle: nil), forCellReuseIdentifier: "noFavouritesCell")
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    checkForFavourites()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    if favourites.count > 0 {
      return favourites.count
    }
    return 1
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if favourites.count > 0 {
      let favProduct = favourites[indexPath.row]
      let favCell = tableView.dequeueReusableCell(withIdentifier: "favouriteCell", for: indexPath) as! FavouriteTableViewCell
      favCell.product = favProduct
      favCell.delegate = self
      return favCell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "noFavouritesCell", for: indexPath)
    return cell
    
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if favourites.count > 0 {
      return 170.0
    }
    return 230
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    performSegue(withIdentifier: "toProductDetailVC", sender: indexPath)
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier ==  "toProductDetailVC") {
      if let indexPath = tableView.indexPathForSelectedRow{
        let selectedRow = indexPath.row
        let productDetailVC = segue.destination as! ProductDetailVC
        productDetailVC.product = self.favourites[selectedRow]
      }
    }
  }
  
  
  fileprivate func checkForFavourites() {
    var allFavourites = [Product]()
    for favProduct in products {
      if favProduct.onFavourites == true {
        allFavourites.append(favProduct)
      }
    }
    self.favourites = allFavourites
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

extension FavouriteTableVC: DeleteFromFavouritesDelegate{
  
  func deleteProduct(cell:UITableViewCell) {
    
    guard let index = tableView.indexPath(for: cell)?.row else { return }
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    self.favourites.remove(at: index)
    self.tableView.deselectRow(at: indexPath, animated: true)
    self.tableView.reloadData()
    
  }
  
}



