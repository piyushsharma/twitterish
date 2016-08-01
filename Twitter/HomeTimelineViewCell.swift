//
//  HomeTimelineViewCell.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/31/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class HomeTimelineViewCell: UITableViewCell {

    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var tStamp: UILabel!
    
    @IBOutlet weak var tweetText: UILabel!
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            let profileUrl = self.tweet.user?.profileUrl
            if let profileUrl = profileUrl {
                self.profileImageView.setImageWithURL(profileUrl)
            }
            self.name.text = self.tweet.user?.name as? String
            let screenName = self.tweet.user?.screenname as! String
            self.twitterHandle.text = "@\(screenName)"
            
            self.tStamp.text = TimeAgo().timeAgoSince(self.tweet.createdAt!)
            self.tweetText.text = self.tweet.text as? String
            
            if tweet.retweetCount > 0 {
                self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
            } else {
                self.retweetCountLabel.text = ""
            }
            
            if tweet.favoritesCount > 0 {
                self.favoriteCountLabel.text = "\(self.tweet.favoritesCount)"
            } else {
                self.favoriteCountLabel.text = ""
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
                                
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
