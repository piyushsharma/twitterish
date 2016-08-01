//
//  TweetDetailViewController.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/31/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var likesCountLabel: UILabel!
    
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var likeImageVIew: UIImageView!
    
    var tweet: Tweet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileUrl = self.tweet.user?.profileUrl
        if let profileUrl = profileUrl {
            self.profileImageView.setImageWithURL(profileUrl)
        }
        
        self.nameLabel.text = self.tweet.user?.name as? String
        let screenName = self.tweet.user?.screenname as! String
        self.handleLabel.text = "@\(screenName)"
        
        let dateObj = self.tweet.createdAt
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M/d/yy, h:mm a"
        dateFormatter.AMSymbol = "AM"
        dateFormatter.PMSymbol = "PM"
        let dateString = dateFormatter.stringFromDate(dateObj!)
        self.timestampLabel.text = dateString
        
        self.tweetTextLabel.text = self.tweet.text as? String
        
        
        self.retweetCountLabel.text = "\(self.tweet.retweetCount)"
        self.likesCountLabel.text = "\(self.tweet.favoritesCount)"
        
        
        self.profileImageView.layer.cornerRadius = 3
        self.profileImageView.clipsToBounds = true
        
        navigationItem.title = "Tweet"
        
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(retweetImageTapped))
        self.retweetImageView.userInteractionEnabled = true
        self.retweetImageView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(favoriteImageTapped))
        self.likeImageVIew.userInteractionEnabled = true
        self.likeImageVIew.addGestureRecognizer(tapGestureRecognizer)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func retweetImageTapped() {
        print ("Test")
        
    }
    
    func favoriteImageTapped() {
        
        print ("Test2")
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
