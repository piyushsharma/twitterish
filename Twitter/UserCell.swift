//
//  UserCell.swift
//  Twitter
//
//  Created by Piyush Sharma on 8/7/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

@objc protocol UserCellDelegate {
    optional func cellRetweeted(cell: UserCell, value: Bool, retweetCount: Int)
    optional func cellFavorited(cell: UserCell, value: Bool, favoriteCount: Int)
    optional func cellReplied(cell: UserCell, tweet: Tweet, value: Bool)
}


class UserCell: UITableViewCell {


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
    
    weak var delegate: UserCellDelegate?
    
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
            
            if (tweet.favorited != nil && tweet.favorited!) {
                favoriteImageView.image = UIImage(named: "like-action-on.png")
            } else {
                favoriteImageView.image = UIImage(named: "like-action.png")
            }
            
            if (tweet.retweeted != nil && tweet.retweeted!) {
                retweetImageView.image = UIImage(named: "retweet-action-on.png")
            } else {
                retweetImageView.image = UIImage(named: "retweet-action.png")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(retweetImageTapped))
        self.retweetImageView.userInteractionEnabled = true
        self.retweetImageView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteImageTapped))
        self.favoriteImageView.userInteractionEnabled = true
        self.favoriteImageView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(replyImageTapped))
        self.replyImageView.userInteractionEnabled = true
        self.replyImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func replyImageTapped() {
        NSLog("Reply to a tweet")
        delegate?.cellReplied?(self, tweet: self.tweet, value: true)
    }
    
    
    func retweetImageTapped() {
        NSLog("User tapped for retweet")
        
        let params = [ "id": "\(self.tweet.idString)"]
        TwitterClient.sharedInstance.postRetweet(self.tweet.idString!, params: params) { (responseDict, error) in
            if (responseDict != nil) {
                
                NSLog("Retweet posted!")
                self.viewDidRetweet()
                
            } else {
                NSLog("error retweeting: \(error)")
            }
            
        }
    }
    
    
    func viewDidRetweet() {
        var retweetCount = Int(self.retweetCountLabel.text!)
        if (retweetCount != nil) {
            retweetCount = retweetCount! + 1
        }
        delegate?.cellRetweeted?(self, value: true, retweetCount: retweetCount!)
    }
    
    
    
    func favoriteImageTapped() {
        let tweetId = self.tweet.idString
        let params = [ "id": "\(tweetId!)" ]
        TwitterClient.sharedInstance.postLike(params) { (responseDict, error) in
            if (responseDict != nil) {
                
                NSLog("Like posted!")
                self.viewDidLike()
                
            } else {
                NSLog("error posting like: \(error)")
            }
        }
    }
    
    func viewDidLike() {
        
        var likeCount = Int(self.favoriteCountLabel.text!)
        if (likeCount != nil) {
            likeCount = likeCount! + 1
        }
        delegate?.cellFavorited?(self, value: true, favoriteCount: likeCount!)
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
