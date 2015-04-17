//
//  UIRedditTableViewCell.swift
//  Assignment 8
//
//  Created by Tom Hart on 3/5/15.
//  Copyright (c) 2015 Tom Hart. All rights reserved.
//

import UIKit

class UIRedditTableViewCell: UITableViewCell {
    

    
    @IBOutlet weak var titleLabel: UILabel!
  
    @IBOutlet weak var commentsButton: UIButton!
    
    @IBOutlet weak var subredditLabel: UILabel!

    @IBOutlet weak var cellBackgroundImage: UIImageView!

    @IBOutlet weak var cellOverlay: UIView!

        
    @IBOutlet weak var commentsView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
