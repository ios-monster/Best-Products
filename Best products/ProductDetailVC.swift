//
//  ProductDetailVC.swift
//  Best products
//
//  Created by Ashot on 5/25/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ImageSlideshow
import Kingfisher
import SCLAlertView

class ProductDetailVC: UIViewController {
  
  let networkService = NetworkService()
  var currentUser:String {
    get{
      return (FIRAuth.auth()?.currentUser?.uid)!
    }
  }
  
  
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
    super.viewDidLoad()
    updateUI()
    
    // Enable zoom to imageSlider
    let sliderTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductDetailVC.didTap))
    sliderView.addGestureRecognizer(sliderTapGesture)
    
    // Adding Gesture to commentView
    
    let commentTapGesture = UITapGestureRecognizer(target: self, action: #selector(ProductDetailVC.goToCommentVC))
    commentView.addGestureRecognizer(commentTapGesture)
    
    self.navigationController?.navigationBar.tintColor = UIColor.white
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateCommentsCount()
  }
  
  @IBAction func addToFavourites(_ sender: Any) {
    
    if FIRAuth.auth()?.currentUser == nil {
      // no user
      let _: SCLAlertViewResponder = SCLAlertView().showInfo("Need an account", subTitle: "To add product to favourites you need to sign in")
      
    } else {
      // user signed in
      
      if product?.onFavourites == true {
        // on favourites yet
        let alert = JDropDownAlert()
        alert.alertWith("Product on favourites yet")
        alert.backgroundColor = UIColor(red: 105/255, green: 135/255, blue: 187/255, alpha: 1)
      }else {
        // not on favourites
        product?.onFavourites = true
        
        if let productRef = self.product?.ref {
          self.networkService.databaseRef.child("Users").child("\(String(describing: currentUser))").child("favouritesProducts").child((self.product?.key)!).setValue(["productRef": String(describing: productRef)])
        }
        
        
        if let productTitle = product?.title {
          let alert = JDropDownAlert()
          alert.alertWith(" Added", message: "\(productTitle) added to favourites", topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(red: 188/255, green: 127/255, blue: 203/255, alpha: 1), delay: 3.0)
          
        }
      }
    }
  }
  
  @IBAction func addToBasket(_ sender: Any) {
    
    if FIRAuth.auth()?.currentUser == nil {
      // no user
      let _: SCLAlertViewResponder = SCLAlertView().showInfo("Need an account", subTitle: "To add product to basket you need to sign in")
      
    } else {
      // user signed in
      
      if product?.onBasket == true {
        // on basket yet
        let alert = JDropDownAlert()
        alert.alertWith("Product on basket yet")
        alert.backgroundColor = UIColor(red: 105/255, green: 135/255, blue: 187/255, alpha: 1)
      }else {
        // not on basket
        product?.onBasket = true
        
        if let productRef = self.product?.ref {
          self.networkService.databaseRef.child("Users").child("\(String(describing: currentUser))").child("productsOnBasket").child((self.product?.key)!).setValue(["productRef": String(describing: productRef)])
        }
        
        if let productTitle = product?.title {
          let alert = JDropDownAlert()
          alert.alertWith(" Added", message: "\(productTitle) added to basket", topLabelColor: UIColor.white, messageLabelColor: UIColor.white, backgroundColor: UIColor(red: 80/255, green: 178/255, blue: 143/255, alpha: 1), delay: 3.0)
          
        }
      }
    }
  }
  
  private func updateCommentsCount() {
    if let commentsCount = product?.comments?.count {
      self.commentsCount.text = String(commentsCount)
    }
  }
  
  private func updateUI() {
    
    sliderView.slideshowInterval = 5
    sliderView.pageControlPosition = .underScrollView
    sliderView.pageControl.pageIndicatorTintColor = UIColor(red: 201/255, green: 203/255, blue: 206/255, alpha: 1)
    sliderView.pageControl.currentPageIndicatorTintColor = UIColor(red: 131/255, green: 131/255, blue: 131/255, alpha: 1)
    
    productTitle.text = product?.title
    productDescription.text = product?.description
    
    
    if let price = product?.price {
      self.productPrice.text = String(describing: "$ \(price)")
    }
    
    if product?.previousPrice != 0.0 {
      if let prevousPrice = product?.previousPrice {
        // Adding struck through to string
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: String(describing: "$ \(prevousPrice)"))
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value:2, range: NSMakeRange(0, attributeString.length ))
        
        self.productPrevoiusPrice.attributedText = attributeString
      }
    } else {
      self.productPrevoiusPrice.text = ""
    }
    
    if let rating = product?.averageRating {
      self.averageRating.text = String(describing: rating)
    }
    
    if let commentsCount = product?.comments?.count {
      self.commentsCount.text = String(commentsCount)
    }
    
    self.newProduct.isHidden = !(product?.newProduct)!
    self.hotProduct.isHidden = !(product?.hotProduct)!
    self.productOnSale.isHidden = !(product?.productOnSale)!
    
    
    // upload images for sliderView
    
    var imagesSources: [ImageSource] = []
    
    if let otherImagesUrls = product?.otherImagesUrls {
      for imageString in otherImagesUrls {
        let imageUrl = URL(string: imageString)
        KingfisherManager.shared.retrieveImage(with: imageUrl!, options: nil, progressBlock: nil
          , completionHandler: { (image, error, cacheType, url) in
            if let image = image {
              let imageSource = ImageSource(image: image)
              imagesSources.append(imageSource)
              self.sliderView.setImageInputs(imagesSources)
            }
        })
        
      }
    }
  }
  
  func didTap() {
    sliderView.presentFullScreenController(from: self)
  }
  
  func goToCommentVC() {
    performSegue(withIdentifier: "toCommentTableVC", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toCommentTableVC" {
      
      let commentTableVC = segue.destination as! CommentTableVC
      
      if let product = self.product {
        commentTableVC.product = product
      }
    }
  }
  
}

















