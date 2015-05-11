//
//  ProfileViewController.swift
//  chirper
//
//  Created by Alex & Chelsea Bryan on 5/10/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.frame.origin.x = 0.0
        
        TwitterClient.sharedInstance.profileTimelineWithParams(nil, completion: { (tweets, error) -> () in
            println("HEYY")
            println("Current User \(_currentUser?.dictionary))")
        })

        // Do any additional setup after loading the view.
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
