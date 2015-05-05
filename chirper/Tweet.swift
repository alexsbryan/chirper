//
//  Tweet.swift
//  chirper
//
//  Created by Alex & Chelsea Bryan on 5/2/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var author: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var idString: String?
    
    init(dictionary: NSDictionary) {
        author = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        idString = dictionary["id_str"] as? String
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        let ago = Int(createdAt!.timeIntervalSinceNow / (60*60)) * -1
        
        if ago < 24 {
            createdAtString = "\(ago)h"
        } else {
            formatter.dateFormat = "MM/dd/yyyy"
            createdAtString = formatter.stringFromDate(createdAt!)
        }
        
    }
    
    func favorite() {
        if idString != nil {
            TwitterClient.sharedInstance.favoriteTweet(idString!)
        }
    }
    
    func retweet() {
        if idString != nil {
            TwitterClient.sharedInstance.retweetTweet(idString!)
        }
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
}
