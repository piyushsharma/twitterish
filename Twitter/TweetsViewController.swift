//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/29/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    var tweets: [Tweet]!
    
    @IBOutlet weak var tweetTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        
        self.tweetTableView.delegate = self
        self.tweetTableView.dataSource = self
        
        self.tweetTableView.rowHeight = UITableViewAutomaticDimension
        self.tweetTableView.estimatedRowHeight = 120
        
        self.fetchTweets(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(fetchTweets(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.tweetTableView.insertSubview(refreshControl, atIndex: 0)        
    }
    
    
    func fetchTweets(refreshControl: UIRefreshControl) {
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            self.tweets = tweets
//                            for tweet in tweets {
//                                print (tweet.favoritesCount)
//                            }
//            
            self.tweetTableView.reloadData()
            refreshControl.endRefreshing()
            
            }, failure: { (error: NSError) in
                print(error.localizedDescription)
        })
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets != nil {
            return self.tweets.count
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("HomeTimelineViewCell", forIndexPath: indexPath) as! HomeTimelineViewCell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
