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
    
    var hamburgerOpenX: CGFloat?
    var hamburgerCloseX = CGFloat(0.0)
    var hamburgerOpen = false
    
    @IBOutlet weak var hamburgerView: UIView!
    @IBOutlet weak var navViewItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.insertSubview(self.refreshControl, atIndex: 0)
        
        hamburgerOpenX = hamburgerView.frame.width
        //position hamburger offscreen
        hamburgerView.frame.origin.x = (-1.0 * hamburgerView.frame.width)
        self.onRefresh()
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

    @IBAction func onViewPanGesture(sender: AnyObject) {
        var point = sender.locationInView(view)
        var velocity = sender.velocityInView(view)
        var translation = sender.translationInView(view)
        
        if sender.state == .Began {
        } else if sender.state == .Changed {
            if translation.x > 0.0 {
                var boundedXTranslation = min(translation.x, hamburgerOpenX!)
                self.hamburgerView.frame.origin.x = (-1.0 * hamburgerView.frame.width) + boundedXTranslation
            
                self.tableView.frame.origin.x = boundedXTranslation
                self.navigationController!.navigationBar.frame.origin.x = boundedXTranslation
            } else if self.hamburgerOpen {
                var boundedXTranslation = max(translation.x, (-1 * hamburgerOpenX!))
                println("bounded X trans \(boundedXTranslation)")
                self.hamburgerView.frame.origin.x = boundedXTranslation
                println("table view x \(boundedXTranslation)")
                self.tableView.frame.origin.x = self.hamburgerView.frame.width + boundedXTranslation
                self.navigationController!.navigationBar.frame.origin.x = self.hamburgerView.frame.width + boundedXTranslation
            }
        } else if sender.state == .Ended {
            if translation.x > 0.0 {
                self.hamburgerView.frame.origin.x = 0.0
                self.tableView.frame.origin.x = self.hamburgerOpenX!
                self.navigationController!.navigationBar.frame.origin.x = self.hamburgerOpenX!
                self.hamburgerOpen = true
            } else if self.hamburgerOpen {
                self.hamburgerView.frame.origin.x = -1 * self.hamburgerOpenX!
                self.tableView.frame.origin.x = 0.0
                self.navigationController!.navigationBar.frame.origin.x = 0.0
                self.hamburgerOpen = false
            }
        }
        
    }

}
