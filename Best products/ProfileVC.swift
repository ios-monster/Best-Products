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

class ProfileVC: UIViewController {
  
  var baseRef: FIRDatabaseReference!

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
  

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.baseRef = FIRDatabase.database().reference()
    
    if FIRAuth.auth()?.currentUser != nil {
      let userRef = baseRef.child("users").child((FIRAuth.auth()?.currentUser?.uid)!)
      userRef.observeSingleEvent(of: .value, with: { (snapshot) in
        let dict = snapshot.value as? NSDictionary

        let fullname = dict?["fullname"] as! String
        let email = dict?["email"] as! String
        self.userFullname.text = fullname
        self.userEmail.text = email
      })
      
    }
    
    
    navigationController?.navigationBar.barTintColor = UIColor(red: 120/255, green: 122/255, blue: 195/255, alpha: 1)
    navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
  }
  
  
  @IBAction func logOutBtnTapped(_ sender: Any) {
    
    try! FIRAuth.auth()?.signOut()
    
  }
  

  @IBAction func signUpBtnTapped(_ sender: Any) {
  }
  
  
  


  
}





























