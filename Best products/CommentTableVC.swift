//
//  CommentTableVC.swift
//  Best products
//
//  Created by Ashot on 5/25/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit

class CommentTableVC: UITableViewController {
  
  var comments:[Comment]? = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return (comments?.count)!
  }
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
    let comment = comments?[indexPath.row]
    cell.comment = comment
    return cell
  }
  
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100.0
  }
  
  @IBAction func addNewCommentTapped(_ sender: Any) {
    
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toNewCommentVC" {
      
      let newCommetnVC = segue.destination as! NewCommentVC
      newCommetnVC.comments = self.comments
      newCommetnVC.delegate = self
    }
  }
  
  
}

extension CommentTableVC: NewCommentDelegate {
  
  func addNewComment(comment: Comment) {
    self.comments?.insert(comment, at: 0)
    tableView.beginUpdates()
    tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
    tableView.endUpdates()
  }
}





































