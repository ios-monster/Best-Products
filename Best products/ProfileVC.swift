//
//  ProfileVC.swift
//  Best products
//
//  Created by Ashot on 5/29/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

class ProfileVC: UIViewController {
  
  var user:User?
  let networkService = NetworkService()
  
  var products = [Product]()
  
  @IBOutlet var logOutBtn: UIBarButtonItem!
  @IBOutlet var emailAndFullnameStack: UIStackView!
  @IBOutlet var nameText: UILabel!
  @IBOutlet var profileImage: UIImageView!
  @IBOutlet var favouritesAndCommentsStack: UIStackView!
  @IBOutlet var favouritesProductsCount: UILabel!
  @IBOutlet var commentsCount: UILabel!
  @IBOutlet var userEmail: UILabel!
  @IBOutlet var userFullname: UILabel!
  @IBOutlet var signUpBtn: UIButton!
  @IBOutlet var productsOnBasketCount: UILabel!
  @IBOutlet var separatorLine: UIView!
  @IBOutlet var noUserView: UIView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tabbar = self.tabBarController as! CustomTabBarController
    self.products = tabbar.products
    self.view.addSubview(noUserView)
    setupConstraintsToNOUserView()
    
    
    //    setTodatabase()
    
    profileImage.layer.cornerRadius = profileImage.frame.height / 2
    profileImage.layer.masksToBounds = true
    profileImage.contentMode = .scaleAspectFill
    
    navigationItem.leftBarButtonItem = nil
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
      if let user = user {
        // User is signed in.
        self.checkForUser()
        self.networkService.databaseRef.child("Users").child(user.uid).observe(.value, with: { (snapshot) in
          
          let newUser = User(snapshot: snapshot)
          self.user = newUser
          
          guard let imageString = newUser.profileImageUrl else {return}
          guard let imageUrl = URL(string: imageString) else {return}
          
          KingfisherManager.shared.retrieveImage(with: imageUrl , options: nil, progressBlock: nil, completionHandler: { (image, error, casheType, url) in
            if error == nil {
              self.profileImage.image = image
            }
          })
          
          self.networkService.databaseRef.child("Users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild("favouritesProducts") {
              self.networkService.databaseRef.child("Users").child(user.uid).child("favouritesProducts").observeSingleEvent(of: .value, with: { (snapshot) in
                
                for product in self.products {
                  
                  if snapshot.hasChild(product.key!) {
                    // product already on favourites
                    product.onFavourites = true
                  }else {
                    // product not on favourites yet
                    product.onFavourites = false
                  }
                  
                }
                
              })
            }
            if snapshot.hasChild("productsOnBasket") {
              self.networkService.databaseRef.child("Users").child(user.uid).child("productsOnBasket").observeSingleEvent(of: .value, with: { (snapshot) in
                for product in self.products {
                  if snapshot.hasChild(product.key!) {
                    // product already on favourites
                    product.onBasket = true
                  }else {
                    // product not on favourites yet
                    product.onBasket = false
                  }
                }
                
              })
            }
          })
          
          DispatchQueue.main.async {
            self.nameText.text = newUser.fullname
            self.userFullname.text = newUser.fullname
            self.userEmail.text = newUser.email
            
            if let commentsCount = newUser.commentsPosted?.count {
              self.commentsCount.text = String(commentsCount)
            }else{
              self.commentsCount.text = "0"
            }
            if let productsOnFavourites  = newUser.productsOnFavourites {
              self.favouritesProductsCount.text = String(productsOnFavourites)
            }
            
            if let productsOnBasket  = newUser.productsOnBasket {
              self.productsOnBasketCount.text = String(productsOnBasket)
            }
          }
        })
        
      } else {
        self.checkForUser()
        self.user = nil
      }
    })
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
  }
  
  @IBAction func logOutBtnTapped(_ sender: Any) {
    
    try! FIRAuth.auth()!.signOut()
    userLogOutUpadateProducts()
    checkForUser()
  }
  
  private func checkForUser() {
    if FIRAuth.auth()?.currentUser == nil {
      // No user
      self.nameText.isHidden = true
      self.favouritesAndCommentsStack.isHidden = true
      self.emailAndFullnameStack.isHidden = true
      self.signUpBtn.isHidden = false
      self.navigationItem.leftBarButtonItem = nil
      self.profileImage.isHidden = true
      self.separatorLine.isHidden = true
      self.noUserView.isHidden = false

      
    }else {
      // User signed in
      self.nameText.isHidden = false
      navigationItem.leftBarButtonItem = logOutBtn
      self.favouritesAndCommentsStack.isHidden = false
      self.emailAndFullnameStack.isHidden = false
      self.profileImage.isHidden = false
      self.separatorLine.isHidden = false
      self.signUpBtn.isHidden = true
      self.noUserView.isHidden = true
    }
  }
  
  
  func userLogOutUpadateProducts() {
    for product in products {
      product.onFavourites = false
      product.onBasket = false
    }
  }
  
  fileprivate func setupConstraintsToNOUserView() {
    self.noUserView.translatesAutoresizingMaskIntoConstraints = false
    let widthConstraint = NSLayoutConstraint(item: noUserView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
    let heightConstraint = NSLayoutConstraint(item: noUserView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
    let horizontalConstraint = NSLayoutConstraint(item: noUserView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
    let verticalConstraint = NSLayoutConstraint(item: noUserView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 100)
    view.addConstraints([horizontalConstraint,verticalConstraint, widthConstraint,heightConstraint])
  } 
}

//public func setTodatabase() {
//
//  let networkingService = NetworkingService()
//
//  let macBookPro = BProduct(title: "13-inch MacBook Pro - Space Gray", descrpiption: "Touch Bar and Touch ID2.9GHz dual-core Intel Core i5 processor, Turbo Boost up to 3.3GHz8GB 2133MHz memory256GB PCIe-based SSD Intel Iris Graphics 550 Four Thunderbolt 3 ports Backlit Keyboard (English) & User's Guide", mainImageUrl: "https://firebasestorage.googleapis.com/v0/b/best-products.appspot.com/o/ProductsImages%2Fmac%20book%20pro%202016%2Fmac%20pro.png?alt=media&token=a15dd2d3-ae08-4dfa-8bda-960f9c05babb", otherImagesUrls: ["https://firebasestorage.googleapis.com/v0/b/best-products.appspot.com/o/ProductsImages%2Fmac%20book%20pro%202016%2Fmac%20pro.png?alt=media&token=a15dd2d3-ae08-4dfa-8bda-960f9c05babb", "https://firebasestorage.googleapis.com/v0/b/best-products.appspot.com/o/ProductsImages%2Fmac%20book%20pro%202016%2FImage%201.png?alt=media&token=5c519a52-ba0b-412b-8db9-2cbe9d9fc6e9", "https://firebasestorage.googleapis.com/v0/b/best-products.appspot.com/o/ProductsImages%2Fmac%20book%20pro%202016%2FImage%203.png?alt=media&token=627771f1-2879-4d27-bd6a-43b72cce6c0a"], price: 1899.0, previousPrice: 2100.0, averageRating: 4.9, estimatedShipping: 80.0, tax: 20.0, newproduct: true, hotProduct: true, productOnSale: true)
//
//    let firstComment = BComment(text: "Very big price(", toProduct: "iphone6sSpaceGrey", addedByUser: "tom22f", dateAdded: Date(), rating: 3.0)
//    let secondComment = BComment(text: "Very cool product, low price, fast shipping", toProduct: "iphone6sSpaceGrey", addedByUser: "alex11", dateAdded: Date(), rating: 5.0)
//
//  let uuid = UUID().uuidString
//
//
//  //
//  networkingService.databaseRef.child("Products").child("macBookPro13Inch").child("comments").child(uuid).setValue(secondComment.toAnyObject())
//
////      networkingService.databaseRef.child("Products").child("macBookPro13Inch").setValue(macBookPro.toAnyObject())
//
//}






























