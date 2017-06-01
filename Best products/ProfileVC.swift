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
  
  var user:BUser?
  
  let networkService = NetworkingService()
  
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
  
  
  var bProducts:[BProduct] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setTodatabase()
    
//    networkService.databaseRef.child("Products").observeSingleEvent(of: .value, with: { (snapshot) in
//      for product in snapshot.children {
//      let product = BProduct(snapshot: product as! FIRDataSnapshot)
//        self.bProducts.append(product)
//        print(product.ref ?? "")
//      }
//    })
    
    
    profileImage.layer.cornerRadius = profileImage.frame.height / 2
    profileImage.layer.masksToBounds = true
    profileImage.contentMode = .scaleAspectFill
    
    navigationItem.leftBarButtonItem = nil
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  }
  
  func uploadProducts()  {
    
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    
    
    FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
      if let user = user {
        // User is signed in.
        self.checkForUser()
        self.networkService.databaseRef.child("users").child(user.uid).observe(.value, with: { (snapshot) in
          
          let newUser = BUser(snapshot: snapshot)
          self.user = newUser
          
          guard let imageString = newUser.profileImageUrl else {return}
          guard let imageUrl = URL(string: imageString) else {return}
          
          KingfisherManager.shared.retrieveImage(with: imageUrl , options: nil, progressBlock: nil, completionHandler: { (image, error, casheType, url) in
            if error == nil {
              self.profileImage.image = image
            }
            
          })
          
          DispatchQueue.main.async {
            self.nameText.text = newUser.fullname
            self.userFullname.text = newUser.fullname
            self.userEmail.text = newUser.email
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
      
    }else {
      // User signed in
      self.nameText.isHidden = false
      navigationItem.leftBarButtonItem = logOutBtn
      self.favouritesAndCommentsStack.isHidden = false
      self.emailAndFullnameStack.isHidden = false
      self.signUpBtn.isHidden = true
    }
  }
  
}

  public func setTodatabase() {
    
    let networkingService = NetworkingService()
    
//    let iphone6s = BProduct(title: "Iphone 6s 4.7-inch Space grey", descrpiption: "32GB Retina HD display with 3D Touch 12-megapixel camera Assisted GPS and GLONASS Digital compass Wi-Fi Cellular", mainImageUrl: "gs://best-products.appspot.com/ProductsImages/iphone 6s space grey/iphone 6s space grey.png", otherImagesUrls: ["gs://best-products.appspot.com/ProductsImages/iphone 6s space grey/Image 2.png", "gs://best-products.appspot.com/ProductsImages/iphone 6s space grey/Image 3.png"], price: 645.0, previousPrice: 900.0, averageRating: 4.9, estimatedShipping: 10.0, tax: 0.0, newproduct: false, hotProduct: true, productOnSale: true)
//
    
//    let firstComment = BComment(text: "Very big price(", toProduct: "iphone6sSpaceGrey", addedByUser: "tom22f", dateAdded: Date(), rating: 3.0)
//    
//        networkingService.databaseRef.child("Products").child("iphone6sSpaceGrey").child("comments").childByAutoId().setValue(firstComment.toAnyObject())

  }
  

  
  
  

























