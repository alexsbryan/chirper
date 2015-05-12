//
//  TwitterClient.swift
//  chirper
//
//  Created by Alex & Chelsea Bryan on 5/2/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import UIKit

let twitterConsumerKey = "1Ciuz57X01nnHyt7WXpyg"
let twitterConsumerSecret = "vGjy5QEsk7lzdFSWaEXXfNj3VGxbsF38NjVOOClrX4"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?

    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //println("got timeline: \(response)")
            
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
                println("failed to get timeline")
        })
        
    }
    
    func profileTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println("got timeline: \(response)")
            
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                completion(tweets: nil, error: error)
                println("failed to get timeline")
        })
        
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token and redirect to auth page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            println("we got a request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            
            UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                println("things went wrong")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openUrl(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("Access token worked")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            self.GET("1.1/account/verify_credentials.json", parameters:nil, success:{ (operation:AFHTTPRequestOperation!, responseObject: AnyObject!)-> Void in
                let response = responseObject as! NSDictionary
                var user = User(dictionary: response)
                User.currentUser = user
                self.loginCompletion?(user:user, error:nil)
                
                NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: userDidLoginNotification, object: nil))
                
                }, failure: {(operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    println(error)
                    self.loginCompletion!(user:nil, error:error)
            })
            }) { (error: NSError!) -> Void in
                println("access token failed")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    func postTweet(tweetText: String, inReplyToIdStr: String="", complete:(()->())?=nil) {
        let params = ["status": tweetText, "in_reply_to_status_id": inReplyToIdStr]
        let urlString = "1.1/statuses/update.json"
        POST(urlString, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("postTweet: success")
            complete?()
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("postTweet: error")
                complete?()
        }
    }
    
    func favoriteTweet(tweetIdStr: String) {
        let params = ["id": tweetIdStr]
        let urlString = "https://api.twitter.com/1.1/favorites/create.json"
        POST(urlString, parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("favoriteTweet: success")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("favoriteTweet: error")
        }
    }
    
    func retweetTweet(tweetIdStr: String) {
        let urlString = "https://api.twitter.com/1.1/statuses/retweet/\(tweetIdStr).json"
        POST(urlString, parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("retweetTweet: success")
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("retweetTweet: error: \(error)")
        }
    }
    
}
