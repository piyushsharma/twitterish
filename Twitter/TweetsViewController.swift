//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/29/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, HomeTimelineViewCellDelegate, TweetDetailViewControllerDelegate {

    var tweets: [Tweet]!
    var userScreenName = User.currentUser?.screenname
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        
        self.tweetTableView.delegate = self
        self.tweetTableView.dataSource = self
        
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetTableView.estimatedRowHeight = 120
        
        NSNotificationCenter.defaultCenter().addObserverForName(Tweet.userComposedNewTweet, object: nil, queue: NSOperationQueue.mainQueue()) { (NSNotification) in
            self.fetchTweets(refreshControl)
        }
        
        self.fetchTweets(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(fetchTweets(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tweetTableView.insertSubview(refreshControl, atIndex: 0)
                
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "twitter-home.png")
        imageView.image = image
        navigationItem.titleView = imageView                
    }
    
        
    func fetchTweets(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
            
//            for tweet in tweets {
//                print (tweet.createdAt)
//            }

            self.tweetTableView.reloadData()
            refreshControl.endRefreshing()
            
            }, failure: { (error: NSError) in
                NSLog(error.localizedDescription)
        })
        
    }
    
    @IBAction func onComposeAction(sender: AnyObject) {
        
        NSLog("Compose new tweet")        
        self.performSegueWithIdentifier("composeSegue", sender: nil)
        
        
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTimelineViewCell", forIndexPath: indexPath) as! HomeTimelineViewCell
        cell.delegate = self
        cell.tweet = self.tweets[indexPath.row]
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        
        TwitterClient.sharedInstance.logout()
        
    }
    
    func cellRetweeted(cell: HomeTimelineViewCell, value: Bool, retweetCount: Int) {
        let indexPath = self.tweetTableView.indexPathForCell(cell)
        let tweet = self.tweets[indexPath!.row]
        tweet.retweeted = value
        tweet.retweetCount = retweetCount
        self.tweets[indexPath!.row] = tweet
        
        tweetTableView.reloadData()
    }
    
    
    func cellFavorited(cell: HomeTimelineViewCell, value: Bool, favoriteCount: Int) {
        let indexPath = self.tweetTableView.indexPathForCell(cell)
        let tweet = self.tweets[indexPath!.row]
        tweet.favorited = value
        tweet.favoritesCount = favoriteCount
        self.tweets[indexPath!.row] = tweet
        
        tweetTableView.reloadData()
    }
    
    
    func cellReplied(cell: HomeTimelineViewCell, tweet: Tweet, value: Bool) {
//        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setObject(tweet, forKey: "replyToTweet")
        self.performSegueWithIdentifier("composeSegue", sender: nil)
    }

    
    func cellShowProfileView(cell: HomeTimelineViewCell, tweet: Tweet, value: Bool) {
        let indexPath = tweetTableView.indexPathForCell(cell)
        let tweet = tweets![indexPath!.row]
        self.userScreenName = tweet.user?.screenname
        self.performSegueWithIdentifier("profileViewSegue", sender: nil)
    }
    
    
    func detailViewRetweeted(tweetDetailController: TweetDetailViewController, value: Bool, retweetCount: Int) {
        tweetDetailController.tweet.retweeted = value
        tweetDetailController.tweet.retweetCount = retweetCount
        tweetDetailController.viewDidLoad()
        tweetTableView.reloadData()
    }
    
    
    func detailViewLiked(tweetDetailController: TweetDetailViewController, value: Bool, favoriteCount: Int) {
        tweetDetailController.tweet.favorited = value
        tweetDetailController.tweet.favoritesCount = favoriteCount
        tweetDetailController.viewDidLoad()
        tweetTableView.reloadData()
    }
    
    
    /*
     MARK: - Navigation
    */
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
       if (segue.identifier == "tweetDetail") {
            let cell = sender as! HomeTimelineViewCell
            let indexPath = tweetTableView.indexPathForCell(cell)
            let tweet = tweets![indexPath!.row]
        
            let detailViewController = segue.destinationViewController as! TweetDetailViewController
            detailViewController.delegate = self
            detailViewController.tweet = tweet
        }
        
        if (segue.identifier == "profileViewSegue") {            
            let profileViewNC = segue.destinationViewController as! UINavigationController
            let profileViewController = profileViewNC.viewControllers.first as! ProfileViewController
            profileViewController.screenName = self.userScreenName as! String
        }

    }
    

}
