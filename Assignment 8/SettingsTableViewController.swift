//
//  SettingsTableViewController.swift
//  
//
//  Created by Tom Hart on 3/12/15.
//
//

import UIKit


struct SubReddit {
    var name: String!
    var color: UIColor!
}

class SettingsTableViewController: UITableViewController {
    
    var subreddits = Handler.getSubreddits()
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
         self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func pressedTheSign(sender: UIButton) {
        
        
        if sender.tag == self.subreddits.count {
            let indexPath = NSIndexPath(forItem: self.subreddits.count, inSection: 0)
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as SettingsTableViewCell
            if cell.subredditInputField.text.utf16Count <= 3 {
                return
            }
            var subreddit = SubReddit(name: cell.subredditInputField.text, color: cell.colorButton.backgroundColor)
            self.subreddits.append(subreddit)
            Handler.saveSubreddits(subreddits)
            self.tableView.reloadData()

        } else {
            self.subreddits.removeAtIndex(sender.tag)
            Handler.saveSubreddits(subreddits)
            self.tableView.reloadData()
            

        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.subreddits.count + 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> SettingsTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as SettingsTableViewCell
        cell.theSign.tag = indexPath.row
        cell.theSign.addTarget(self, action: "pressedTheSign:", forControlEvents: .TouchUpInside)

        if indexPath.row == self.subreddits.count {
            
            cell.colorButton.backgroundColor = cell.getRandomColor()
            cell.colorButton.enabled = true
            cell.subredditInputField.borderStyle = .RoundedRect
            cell.subredditInputField.userInteractionEnabled = true
            cell.subredditInputField.text = ""
            cell.theSign.setTitle("+", forState: .Normal)

        } else {
            
            var subreddit = subreddits[indexPath.row]
            cell.colorButton.backgroundColor = subreddit.color
            cell.colorButton.enabled = false
            cell.subredditInputField.borderStyle = .None
            cell.subredditInputField.userInteractionEnabled = false
            cell.subredditInputField.text = subreddit.name
            cell.theSign.setTitle("−", forState: .Normal)
            
        }

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
