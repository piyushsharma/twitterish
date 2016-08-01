//
//  TwitterClient.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/29/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
        
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"),
                                              consumerKey: "ms4pzEjYtakhKg6VWEgV9a9R3",
                                              consumerSecret:  "GZNGLovZpLesSvQYOF0DhFDq1hIC8SCRtaZUe3fHPJKL2rvynR")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    
    func handleOpenUrl(url: NSURL) {
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken,
                success: { (accessToken: BDBOAuth1Credential!) in
                
                    NSLog("Got the access token")
                    self.currentAccount({ (user: User) in
                    
                        User.currentUser = user
                        self.loginSuccess?()
                        
                    }, failure: { (error: NSError) in
                        
                        self.loginFailure?(error)
                        
                    })
                    
                }) { (error: NSError!) -> Void in
                    
                    self.loginFailure?(error)
                    
                }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                let userDictionary = response as! NSDictionary
                let user = User(dictionary: userDictionary)
                success(user)
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                
                failure(error)
                NSLog("Failed to login: \(error.localizedDescription)")
                
            }
        )
    }
    
    func logout() {
        
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogOutNotification, object: nil)
        
        NSLog("Logged out")
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil,
            success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                
                let tweetDictionary = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(tweetDictionary)
                success(tweets)
                
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
            }
        )
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        TwitterClient.sharedInstance.deauthorize()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
            
        }) { (error: NSError!) -> Void in
            
            NSLog ("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }                
    }
    
}