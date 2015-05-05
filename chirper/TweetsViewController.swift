//
//  TweetsViewController.swift
//  chirper
//
//  Created by Alex & Chelsea Bryan on 5/2/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.onRefresh()
        
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoggedOut(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("TweetRowTableCell", forIndexPath: indexPath) as! TweetRowTableCell
        
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
    
    func onRefresh() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if let identifier = segue.identifier {
            if (identifier == "tweetDetail") {
                let cell = sender as! TweetRowTableCell
                let indexPath = tableView.indexPathForCell(cell)!
                
                let tweet = tweets![indexPath.row]
                
                let tweetDetailsViewController = segue.destinationViewController as! TweetViewController
                
                tweetDetailsViewController.tweet = tweet
            } else if (identifier == "newTweet") {
                
            }
        }
        
    }


}
