//
//  CommentTableVC.swift
//  Best products
//
//  Created by Ashot on 5/25/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import SCLAlertView

class CommentTableVC: UITableViewController {
  
  var product:Product?
  
  let networkService = NetworkService()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    product?.comments?.sort(by: {$0.dateAdded! > $1.dateAdded!})
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (product?.comments?.count)!
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
    
    if let comment = product?.comments?[indexPath.row] {
      cell.comment = comment
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80.0
  }
  
  @IBAction func addNewCommentTapped(_ sender: Any) {
    
    if FIRAuth.auth()?.currentUser == nil {
      let _: SCLAlertViewResponder = SCLAlertView().showInfo("Need an account", subTitle: "To add new comments please sign in")
    }else {
      performSegue(withIdentifier: "toNewCommentVC", sender: self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toNewCommentVC" {
      let newCommetnVC = segue.destination as! NewCommentVC
      newCommetnVC.product = self.product
      newCommetnVC.delegate = self
    }
  }

}

extension CommentTableVC: NewCommentDelegate {
  
  func addNewComment(commentKey:String) {
    let commentRef = networkService.databaseRef.child("Products").child((product?.key)!).child("comments").child(commentKey)
    commentRef.observe(.value, with: { (snapshot) -> Void in
      let newComment = Comment(snapshot: snapshot)
      self.product?.comments?.insert(newComment, at: 0)
      DispatchQueue.main.async {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        self.tableView.endUpdates()
      }
    })
  }
}

