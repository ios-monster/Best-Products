//
//  CommentTableViewCell.swift
//  Best products
//
//  Created by Ashot on 5/25/17.
//  Copyright © 2017 ios.monster. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

  var comment: Comment? {
    didSet{
      updateUI()
    }
  }
  
  @IBOutlet weak var username: UILabel!
  @IBOutlet weak var rating: UILabel!
  @IBOutlet weak var commentText: UILabel!
  @IBOutlet weak var dateAdded: UILabel!
  
  
  func updateUI() {
    
    self.username.text = comment?.addedByUser
    
    if let rating = comment?.rating {
      self.rating.text = String(rating)

    }
    
    self.commentText.text = comment?.text
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd-MM-yy"
    let dateString = formatter.string(from: (comment?.dateAdded)!)
    self.dateAdded.text = dateString
    
  }

}
