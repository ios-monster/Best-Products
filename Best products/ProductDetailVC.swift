//
//  ProductDetailVC.swift
//  Best products
//
//  Created by Ashot on 5/25/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import ImageSlideshow

class ProductDetailVC: UIViewController {
  
  var product: Product?
  
  // Outlets
  @IBOutlet weak var sliderView: ImageSlideshow!
  @IBOutlet weak var newProduct: UIView!
  @IBOutlet weak var hotProduct: UIView!
  @IBOutlet weak var productOnSale: UIView!
  @IBOutlet weak var averageRating: UILabel!
  @IBOutlet weak var productTitle: UILabel!
  @IBOutlet weak var productDescription: UILabel!
  @IBOutlet weak var productPrice: UILabel!
  @IBOutlet weak var productPrevoiusPrice: UILabel!
  @IBOutlet weak var commentsCount: UILabel!
  @IBOutlet weak var commentView: UIView!
  
  override func viewDidLoad() {
    
    // Enable zoom to imageSlider
    let sliderTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductDetailVC.didTap))
    sliderView.addGestureRecognizer(sliderTapGesture)
    
    // Adding Gesture to commentView 
    
    let commentTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductDetailVC.goToCommentVC))
    commentView.addGestureRecognizer(commentTapGesture)
    
    super.viewDidLoad()
    updateUI()
    self.navigationController?.navigationBar.tintColor = UIColor.white
  }
  
  
  
  @IBAction func addToFavourites(_ sender: Any) {
  }
  
  @IBAction func addToBasket(_ sender: Any) {
  }
  
  
 private func updateUI() {
    
    sliderView.contentScaleMode = .scaleAspectFit
    sliderView.slideshowInterval = 4
  
    
    productTitle.text = product?.title
    productDescription.text = product?.description
    
    
    if let price = product?.price {
      self.productPrice.text = String(describing: "$ \(price)")
    }
    
    if let prevousPrice = product?.previousPrice {
      self.productPrevoiusPrice.text = String(describing: "$ \(prevousPrice)")
    }
    
    
    if let rating = product?.averageRating {
      self.averageRating.text = String(describing: rating)
    }
    
    if let commentsCount = product?.comments?.count {
      self.commentsCount.text = String(commentsCount)
    }
    
    self.newProduct.isHidden = !(product?.newProduct)!
    self.hotProduct.isHidden = !(product?.hotProduct)!
    self.productOnSale.isHidden = !(product?.saleProduct)!
    
    
    var imagesSource: [ImageSource] = []
    
    if let images = product?.images {
      for i in images {
        let image = ImageSource(image: i)
        imagesSource.append(image)
      }
    }
    
    self.sliderView.setImageInputs(imagesSource)
  }
  
  func didTap() {
   self.sliderView.presentFullScreenController(from: self)
  }
  
  func goToCommentVC() {
    performSegue(withIdentifier: "toCommentTableVC", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toCommentTableVC" {
      
      let commentTableVC = segue.destination as! CommentTableVC
      
      if let comments = product?.comments {
        commentTableVC.comments = comments
      }
    }
  }
  
}



























