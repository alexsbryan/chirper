//
//  ProfileViewController.swift
//  chirper
//
//  Created by Alex & Chelsea Bryan on 5/10/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var profileDictionary: NSDictionary?
    var tweets: [Tweet]?
    
    var user: User?

    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.frame.origin.x = 0.0
        tableView.dataSource = self
        tableView.delegate = self
        
        if (self.user != nil) {
            self.profileDictionary = self.user?.dictionary
        } else {
            self.user = _currentUser
            self.profileDictionary = _currentUser?.dictionary
        }
        
        var params = [String: String]()
        params["screen_name"] = self.user?.screenname!
        TwitterClient.sharedInstance.profileTimelineWithParams(params, completion: { (tweets, error) -> () in
            self.tweets = tweets
            
            self.tweetCountLabel.text = (self.profileDictionary!["statuses_count"] as? NSNumber)?.stringValue
            self.followingCountLabel.text = (self.profileDictionary!["following"] as? NSNumber)?.stringValue
            self.followerCountLabel.text = (self.profileDictionary!["followers_count"] as? NSNumber)?.stringValue
            self.nameLabel.text = self.user?.name
            if let backgroundImage = self.profileDictionary!["profile_banner_url"] {
                self.backgroundImage.setImageWithURL(NSURL(string: backgroundImage as! String))
            }
            
            if let pImage = self.user?.profileImageUrl {
                self.profileImage.setImageWithURL(NSURL(string: pImage))
            }
            
            self.tableView.reloadData()
            println("\(self.user?.dictionary)")
        })

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var handleLabel: UILabel!
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            var cell = tableView.dequeueReusableCellWithIdentifier("ProfileTweetCell", forIndexPath: indexPath) as! ProfileTweetRowTableCell
            
            cell.setTweet(self.tweets![indexPath.row])
            
            return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
