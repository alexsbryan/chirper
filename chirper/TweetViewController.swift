//
//  TweetViewController.swift
//  chirper
//
//  Created by Alex & Chelsea Bryan on 5/4/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController {
    
    var tweet: Tweet!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Yo it's \(tweet.text)")
        
        if let user = tweet.author {
            
            self.nameLabel.text = user.name
            self.timeLabel.text = tweet.createdAtString
            self.tweetLabel.text = tweet.text
            if let imageUrl = user.profileImageUrl {
                profileImage.setImageWithURL(NSURL(string: imageUrl))
            }
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        tweet.favorite()
        self.favoriteButton.alpha = 0.3
    }

    @IBAction func onRetweet(sender: AnyObject) {
        tweet.retweet()
        self.retweetButton.alpha = 0.3
    }
    
    @IBAction func onReply(sender: AnyObject) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
