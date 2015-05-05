//
//  TweetRowTableCell.swift
//  chirper
//
//  Created by Alex & Chelsea Bryan on 5/4/15.
//  Copyright (c) 2015 Alex. All rights reserved.
//

import UIKit

class TweetRowTableCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTweet(tweet: Tweet) -> Void {
        var user = tweet.author
        self.nameLabel.text = user?.name
        self.timeStampLabel.text = tweet.createdAtString
        self.tweetLabel.text = tweet.text
        if let imageUrl = user?.profileImageUrl {
        profileImage.setImageWithURL(NSURL(string: imageUrl))
        }
    }

}
