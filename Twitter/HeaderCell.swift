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
    @IBOutlet weak var numberFollowingLabel: UILabel!
    @IBOutlet weak var numberFollowersLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
    var profileUrl: NSURL!
    
    var userInfo: NSDictionary!
    
    override func awakeFromNib() {
        super.awakeFromNib()
                        
        let profileUrlString = self.userInfo["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            self.profileUrl = NSURL(string: profileUrlString)
        }
        
        if let profileUrl = profileUrl {
            self.profileImageView.setImageWithURL(profileUrl)
        }
        
        self.nameLabel.text = self.userInfo["name"] as? String
        let screenName = self.userInfo["screen_name"] as? String
        self.handleLabel.text = "@\(screenName)"
        
        self.numberFollowersLabel.text = self.userInfo["followers_count"] as? String
        self.numberFollowingLabel.text = self.userInfo["friends_count"] as? String

        self.followingLabel.text = "FOLLOWING"
        self.followersLabel.text = "FOLLOWERS"
        
        // Initialization code
    }
    
}
