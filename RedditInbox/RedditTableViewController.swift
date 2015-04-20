//
//  RedditTableViewController.swift
//  RedditInbox
//
//  Created by Tom Hart on 3/5/15.
//  Copyright (c) 2015 Tom Hart. All rights reserved.
//


//        PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//        testObject[@"foo"] = @"bar";
//        [testObject saveInBackground];
//        var testObject = PFObject(className: "Posts")
//        testObject["posts"] = [
//            [
//                "Tom": "this was a grat day",
//                "time": 4,
//                "hello": "by"
//            ]
//        ]

//        testObject.saveInBackgroundWithBlock {
//            success, error in
//            println("eff yea success was: \(success)")
//        }
//
//        PFQuery(className: "Posts").getFirstObjectInBackgroundWithBlock {
//            object, error in
//            if error != nil { println("ERROR: \(error)") }
//            println("returned object:\(object)")
//        }

import UIKit
import Alamofire
import SwiftyJSON
import QuartzCore


class RedditTableViewController: UITableViewController {
    
//    var inbox = Handler.getInbox()
    var posts:[Post]!
    var type = "inbox"
    var subredditColors = [String:UIColor]()

    override func viewDidLoad() {
        //Handler.saveInbox([Post]())
        
        super.viewDidLoad()
        
        self.setup()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if type == "inbox" {
            self.getPosts()
        
        }
        for subreddit in Handler.getSubreddits() {
            subredditColors.updateValue(subreddit.color, forKey: subreddit.name)
        }
        
    }
    
    func setup(){
        if type == "inbox"{
            self.posts = Handler.getInbox()
            var rightButton = UIBarButtonItem(title: "Favs", style: UIBarButtonItemStyle.Plain, target: self, action: "pressFavs")
            self.navigationItem.setRightBarButtonItem(rightButton, animated: false)
            var gestureRight = UISwipeGestureRecognizer(target: self, action: "didSwipeRight:")
            var gestureLeft = UISwipeGestureRecognizer(target: self, action: "didSwipeLeft:")
            gestureRight.direction = UISwipeGestureRecognizerDirection.Right
            gestureLeft.direction = UISwipeGestureRecognizerDirection.Left
            tableView.addGestureRecognizer(gestureRight)
            tableView.addGestureRecognizer(gestureLeft)
        }else {
            self.posts = Handler.getFavorites()
            self.navigationItem.leftBarButtonItem = nil
            var gestureLeft = UISwipeGestureRecognizer(target: self, action: "didSwipeLeft:")
            gestureLeft.direction = UISwipeGestureRecognizerDirection.Left
            tableView.addGestureRecognizer(gestureLeft)
        }
    }
    func getPosts() {
        for subreddit in Handler.getSubreddits() {
            getPost("http://www.reddit.com/\(subreddit.name).json")
        }
    }
    func getPost(string: String) {
        Alamofire.request(.GET, string).responseJSON {
            
            _, _, json, _ in
            
            var newPosts = [Post]()
            let stuff = JSON(json!)
            if let newArray = stuff["data"]["children"].array {
                for index in 0...4{
                    var data = newArray[index]["data"].object as [String: AnyObject]
                    var post = Post(json: data)
                    newPosts.append(post)
                }
                Handler.updateInbox(newPosts)
                self.posts = Handler.getInbox()
                self.tableView.reloadData()
            }
        }
    }
    
    func pressFavs(){
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var favsVC = storyboard.instantiateViewControllerWithIdentifier("RedditTableViewController") as RedditTableViewController
        favsVC.type = "favs"
        self.navigationController?.pushViewController(favsVC, animated: true)
        
    }
    
    func commentsButtonPressed(sender: UIButton) {
        var url = posts[sender.tag].permalink
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var webVC = storyboard.instantiateViewControllerWithIdentifier("WebViewController") as WebViewController
        webVC.url = "http://reddit.com" + url + ".compact"
        let navigationVC = UINavigationController(rootViewController: webVC)
        self.navigationController!.presentViewController(navigationVC, animated: true, completion: nil)
    }
    
    func cellPressed(sender: UIButton) {
        var url = posts[sender.tag].url
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        var webVC = storyboard.instantiateViewControllerWithIdentifier("WebViewController") as WebViewController
        webVC.url = url
        let navigationVC = UINavigationController(rootViewController: webVC)
        self.navigationController!.presentViewController(navigationVC, animated: true, completion: nil)
    }
    
    func didSwipeRight(sender: UISwipeGestureRecognizer){
        swiped(sender)
    }
    
    func didSwipeLeft(sender: UISwipeGestureRecognizer){
        swiped(sender)
    }
    
    func swiped(sender: UISwipeGestureRecognizer ) {
        if sender.state != UIGestureRecognizerState.Ended {
            return
        }
        let point = sender.locationInView(self.tableView)
        if let indexPath = self.tableView.indexPathForRowAtPoint(point) {
            if sender.direction == .Right {
                // DONT FORGET !!! Save into Favs
                let post = posts[indexPath.row]
                Handler.appendFavorites([post])
                self.posts.removeAtIndex(indexPath.row)
                Handler.saveInbox(self.posts)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
            } else {
                // DONT FORGET TO SAVE TO DELTEED
                let post = posts[indexPath.row]
                Handler.appendDeleted([post])
                self.posts.removeAtIndex(indexPath.row)
                if type == "inbox"{
                    Handler.saveInbox(posts)
                }else {
                    Handler.saveFavorites(posts)
                }
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
            }
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
        return self.posts.count
    }

//    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        var url = inbox[indexPath.row].url
//        println(indexPath.row)
//        var storyboard = UIStoryboard(name: "Main", bundle: nil)
//        var webVC = storyboard.instantiateViewControllerWithIdentifier("WebViewController") as WebViewController
//        webVC.url = url
//        let navigationVC = UINavigationController(rootViewController: webVC)
//        self.navigationController!.presentViewController(navigationVC, animated: true, completion: nil)
//    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UIRedditTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("redditCell", forIndexPath: indexPath) as UIRedditTableViewCell
        let post = self.posts[indexPath.row]
        cell.titleLabel.text = post.title
        
        var button = UIButton(frame: cell.cellOverlay.bounds)
        button.tag = indexPath.row
        button.addTarget(self, action: "cellPressed:", forControlEvents: .TouchUpInside)
        cell.cellOverlay.addSubview(button)
        cell.subredditLabel.text = "r/\(post.subreddit)"
        cell.commentsButton.addTarget(self, action: "commentsButtonPressed:", forControlEvents: .TouchUpInside)
        cell.commentsButton.tag = indexPath.row
        
        
        if let color = subredditColors["r/\(post.subreddit)"] {
            
            cell.commentsView.backgroundColor = color
            cell.subredditLabel.backgroundColor = color
            cell.subredditLabel.layer.cornerRadius = 2
            cell.subredditLabel.layer.masksToBounds = true
            
        } else {
            println("somethings wrong")
        }
        
        
        
        let url = post.thumbnail
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string:url)!, completionHandler: { (data, response, error) -> Void in
            if (data != nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.cellBackgroundImage.image = UIImage(data: data)
                })
            }
            
        }).resume()
        
        return cell
    }

}
