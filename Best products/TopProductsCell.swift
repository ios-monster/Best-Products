//
//  TopProductsCell.swift
//  Best products
//
//  Created by Ashot on 5/24/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit

class TopProductsCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  

  @IBOutlet weak var collectionView: UICollectionView!
  
  var favouritesProducts: [Product] = []

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return favouritesProducts.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let product = favouritesProducts[indexPath.row]
    let topProductCell = collectionView.dequeueReusableCell(withReuseIdentifier: "topProductCell", for: indexPath) as! TopProductsCollectionViewCell
    topProductCell.product = product
    return topProductCell
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width: 180, height: 110)
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(0, 10, 0, 10)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
   func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if (segue.identifier ==  "toProductDetailVC") {
      if let indexPath = self.collectionView.indexPath(for: sender as! TopProductsCollectionViewCell) {
        let productDetailVC = segue.destination as! ProductDetailVC
        productDetailVC.product = self.favouritesProducts[indexPath.item]
      }
    }
  }
  
}

class TopProductsCollectionViewCell: UICollectionViewCell {
  
  var product: Product? {
    
    didSet{
      updateUI()
    }
    
  }
  @IBOutlet weak var imageView: UIImageView!
  
  func updateUI() {
    
    if let mainImage = product?.productMainImage {
      self.imageView.image = mainImage
    }
    
  }
}


















