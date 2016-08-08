//
//  ProfileViewController.swift
//  Twitter
//
//  Created by Piyush Sharma on 8/7/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, TweetDetailViewControllerDelegate, UserCellDelegate {

    var tweets: [Tweet]!
    
    var userInfo: NSDictionary!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let params = ["screen_name": "_psharma"]
//        TwitterClient.sharedInstance.userDetail(params, success: { (userInfo: NSDictionary) in
//            self.userInfo = userInfo
//            print(self.userInfo)
//            
//            }, failure: { (error: NSError) in
//                NSLog(error.localizedDescription)
//        })
//        
        let refreshControl = UIRefreshControl()
        
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.profileTableView.estimatedRowHeight = 120
        
        NSNotificationCenter.defaultCenter().addObserverForName(Tweet.userComposedNewTweet, object: nil, queue: NSOperationQueue.mainQueue()) { (NSNotification) in
            self.fetchTweets(refreshControl)
        }
        
        self.fetchTweets(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(fetchTweets(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.profileTableView.insertSubview(refreshControl, atIndex: 0)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "twitter-home.png")
        imageView.image = image
        navigationItem.titleView = imageView
        
        
        var cellNib = UINib(nibName: "UserCell", bundle: NSBundle.mainBundle())
        self.profileTableView.registerNib(cellNib, forCellReuseIdentifier: "UserCell")

        cellNib = UINib(nibName: "HeaderCell", bundle: NSBundle.mainBundle())
        self.profileTableView.registerNib(cellNib, forHeaderFooterViewReuseIdentifier: "HeaderCell")
    }
    
    
    func fetchTweets(refreshControl: UIRefreshControl) {
        
        let params = ["screen_name": "_psharma"]
        
        TwitterClient.sharedInstance.userDetail(params, success: { (userInfo: NSDictionary) in
                self.userInfo = userInfo
            
                TwitterClient.sharedInstance.userTimeline(params, success: { (tweets: [Tweet]) in
                        self.tweets = tweets
                        self.profileTableView.reloadData()
                        refreshControl.endRefreshing()
                
                    }, failure: { (error: NSError) in
                        NSLog(error.localizedDescription)
                })
            
            }, failure: { (error: NSError) in
                NSLog(error.localizedDescription)
        })
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 120.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.userInfo != nil {
            print (self.userInfo)
            
            let cell = tableView.dequeueReusableHeaderFooterViewWithIdentifier("HeaderCell") as! HeaderCell
            cell.userInfo = self.userInfo
            print("TEST")
            print (cell.userInfo)
            return cell
        }
        
        let vw = UIView()
        vw.backgroundColor = UIColor.whiteColor()
        return vw
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell
        cell.delegate = self
        cell.tweet = self.tweets[indexPath.row]
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        return cell
        
    }
    
    
    func cellRetweeted(cell: UserCell, value: Bool, retweetCount: Int) {
        let indexPath = self.profileTableView.indexPathForCell(cell)
        let tweet = self.tweets[indexPath!.row]
        tweet.retweeted = value
        tweet.retweetCount = retweetCount
        self.tweets[indexPath!.row] = tweet
        
        profileTableView.reloadData()
    }
    
    
    func cellFavorited(cell: UserCell, value: Bool, favoriteCount: Int) {
        let indexPath = self.profileTableView.indexPathForCell(cell)
        let tweet = self.tweets[indexPath!.row]
        tweet.favorited = value
        tweet.favoritesCount = favoriteCount
        self.tweets[indexPath!.row] = tweet
        
        profileTableView.reloadData()
    }
    
    
    func cellReplied(cell: UserCell, tweet: Tweet, value: Bool) {        
        self.performSegueWithIdentifier("composeSegue", sender: nil)
    }
    
    func detailViewRetweeted(tweetDetailController: TweetDetailViewController, value: Bool, retweetCount: Int) {
        tweetDetailController.tweet.retweeted = value
        tweetDetailController.tweet.retweetCount = retweetCount
        tweetDetailController.viewDidLoad()
        profileTableView.reloadData()
    }
    
    
    func detailViewLiked(tweetDetailController: TweetDetailViewController, value: Bool, favoriteCount: Int) {
        tweetDetailController.tweet.favorited = value
        tweetDetailController.tweet.favoritesCount = favoriteCount
        tweetDetailController.viewDidLoad()
        profileTableView.reloadData()
    }
    
    
    /*
     MARK: - Navigation
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "tweetDetail") {
            let cell = sender as! HomeTimelineViewCell
            let indexPath = profileTableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! TweetDetailViewController
            detailViewController.delegate = self
            detailViewController.tweet = tweet
        }
        
    }

}
