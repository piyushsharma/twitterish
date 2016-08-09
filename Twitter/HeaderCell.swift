//
//  HeaderCell.swift
//  Twitter
//
//  Created by Piyush Sharma on 8/7/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewHeaderFooterView {

    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var numberFollowingLabel: UILabel!
    @IBOutlet weak var numberFollowersLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    var profileUrl: NSURL!
    
    var userInfo: NSDictionary!
    
    
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
//        print("++++++++++++++++++")
//        print(self.userInfo)
//        print("++++++++++++++++++")
        
        let profileUrlString = self.userInfo["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            self.profileUrl = NSURL(string: profileUrlString)
        }
        
        if let profileUrl = profileUrl {
            self.profileImageView.setImageWithURL(profileUrl)
        }
        
        self.nameLabel.text = self.userInfo["name"] as? String
        let screenName = self.userInfo["screen_name"] as! String
        self.handleLabel.text = "@\(screenName)"
        
        let numberFollowers = self.userInfo["followers_count"] as! Int
        self.numberFollowersLabel.text = "\(numberFollowers)"
        
        let numberFollowing = self.userInfo["friends_count"] as! Int
        self.numberFollowingLabel.text = "\(numberFollowing)"
        
        self.followingLabel.text = "FOLLOWING"
        self.followersLabel.text = "FOLLOWERS"
        
        self.editProfileButton.setTitle("Edit Profile", forState: .Normal)
        self.editProfileButton.frame = CGRectMake(0, 0, self.contentView.bounds.width, self.contentView.bounds.height)

    }
    
}
