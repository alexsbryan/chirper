//
//  NewTweetViewController.swift
//  chirper
//
//  Created by Alex & Chelsea Bryan on 5/4/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import UIKit

class NewTweetViewController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = _currentUser {
            self.nameLabel.text = user.name
            self.handleLabel.text = user.screenname
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
    
    
    @IBAction func onTweet(sender: AnyObject) {
        
        TwitterClient.sharedInstance.postTweet(tweetTextField.text, inReplyToIdStr: "") { () -> () in
            println("Tweet Posted")
            self.navigationController?.popViewControllerAnimated(true)
        }
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
