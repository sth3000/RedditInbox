//
//  SettingsTableViewCell.swift
//  RedditInbox
//
//  Created by Tom Hart on 3/12/15.
//  Copyright (c) 2015 Tom Hart. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var subredditInputField: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    
    //when launching app initialize this table with /funny and a random color
    //when adding new subreddit, write to user default and empty subreddit and random  color
    //then reload table 
    
    @IBAction func colorButtonPressed(sender: AnyObject) {
        self.colorButton.backgroundColor = getRandomColor()
    }
    @IBOutlet weak var theSign: UIButton!
    
    func getRandomColor() -> UIColor{
        var randomRed:CGFloat = CGFloat(drand48())
        var randomGreen:CGFloat = CGFloat(drand48())
        var randomBlue:CGFloat = CGFloat(drand48())
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
