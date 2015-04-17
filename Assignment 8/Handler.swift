//
//  Handler.swift
//  Assignment 8
//
//  Created by Tom Hart on 3/11/15.
//  Copyright (c) 2015 Tom Hart. All rights reserved.
//

import Foundation

struct Post {
    
    var title: String
    var subreddit: String
    var url: String
    var thumbnail: String
    var permalink: String
    
    init(json: [String:AnyObject]){

        self.title = json["title"] as String
        self.subreddit = json["subreddit"] as String
        self.url = json["url"] as String
        self.thumbnail = json["thumbnail"] as String
        self.permalink = json["permalink"] as String
    }
}

class Handler {
    
    class func saveSubreddits(subreddits:[SubReddit]) {
        var dictionaries = [Dictionary<String, AnyObject>]()
        for subreddit in subreddits {
            var data = NSKeyedArchiver.archivedDataWithRootObject(subreddit.color!)
            let dictionary = [
                "name": subreddit.name!,
                "color": data,
            ]
            dictionaries.append(dictionary)
        }
        
        NSUserDefaults.standardUserDefaults().setObject(dictionaries, forKey: "subreddits")
    }
    
    class func getSubreddits() -> [SubReddit] {
        var subreddits = [SubReddit]()
        if let dicts = NSUserDefaults.standardUserDefaults().objectForKey("subreddits") as? [Dictionary<String, AnyObject>] {
            for dict in dicts {
                let name = dict["name"] as String
                let colorData = dict["color"] as NSData
                var subreddit = SubReddit(name:  name, color: NSKeyedUnarchiver.unarchiveObjectWithData(colorData) as? UIColor)
                subreddits.append(subreddit)
            }
        }
        return subreddits
    }
    
    class func generatePosts(dictionaries: [Dictionary<String, String>]) -> [Post] {
        var posts = [Post]()
        for dict in dictionaries {
            posts.append(Post(json: dict))
        }
        return posts
    }
    
    class func generateDictionaryArray(posts: [Post]) -> [Dictionary<String, AnyObject>] {
        var dictionaries = [Dictionary<String, AnyObject>]()
        for post in posts {
            let dictionary = [
                "title": post.title,
                "subreddit": post.subreddit,
                "url": post.url,
                "thumbnail": post.thumbnail,
                "permalink": post.permalink,
            ]
            dictionaries.append(dictionary)
        }
        return dictionaries
    }

    class func saveInbox(posts: [Post]) { saveWithKey(posts, key: "inbox") }
    class func saveDeleted(posts: [Post]) { saveWithKey(posts, key: "deleted") }
    class func saveFavorites(posts: [Post]) { saveWithKey(posts, key: "favorites") }
    
    class func appendDeleted(posts: [Post]){
        var newposts = posts
        newposts.extend(getDeleted())
        saveDeleted(newposts)
    
    }
    class func appendFavorites(posts:[Post]){
        var newposts = posts
        newposts.extend(getFavorites())
        saveFavorites(newposts)
    }
    
    
    class func saveWithKey(posts: [Post], key:String) {
        NSUserDefaults.standardUserDefaults().setObject(generateDictionaryArray(posts), forKey: key)
    }
    
    class func getInbox() -> [Post] { return getWithKey("inbox")
    }
    class func getDeleted() -> [Post] { return getWithKey("deleted")
    }
    class func getFavorites() -> [Post] { return getWithKey("favorites") }
    
    class func getWithKey(key: String) -> [Post] {
        if let dicts = NSUserDefaults.standardUserDefaults().objectForKey(key) as? [Dictionary<String, String>] {
            return generatePosts(dicts)
        }
        return [Post]()
    }
    
    class func doesItContain(post: Post, posts: [Post]) -> Bool {
        for oldPost in posts {
            if oldPost.permalink == post.permalink { return true }
        }
        return false
    }
    
    
    class func updateInbox(posts: [Post]) {
        var newPosts = posts
        var inbox = getInbox()
        var deleted = getDeleted()
        var favorites = getFavorites()
        var postsToRemove = [Int]()
        for post in newPosts  {
            
        }
        
        var filtered = newPosts.filter {
            element in
            if self.doesItContain(element, posts: inbox)
            || self.doesItContain(element, posts: deleted)
            || self.doesItContain(element, posts: favorites) {
                return false
            }
            return true
        }
        filtered.extend(inbox)
        saveInbox(filtered)
    }
    
}




