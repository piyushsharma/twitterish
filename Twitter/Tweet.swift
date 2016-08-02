//
//  Tweet.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/28/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var text: NSString?
    var createdAt: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileImageUrl: NSURL?
    var user: User?
    var idString: String?
    var favorited: Bool?
    var retweeted: Bool?
    
    static let userComposedNewTweet = "userComposedNewTweet"
    
    init(dictionary: NSDictionary) {
        
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        //"created_at": "Fri Oct 19 15:51:49 +0000 2012",
        let createdAtString = dictionary["created_at"] as? String
        if let createdAtString = createdAtString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            createdAt = formatter.dateFromString(createdAtString)
        }
        
        let userDictionary = dictionary["user"] as? NSDictionary
        if let userDictionary = userDictionary {
            user = User(dictionary: userDictionary)
        }
        
        idString = dictionary["id_str"] as? String
        
        favorited = dictionary["favorited"] as? Bool
        retweeted = dictionary["retweeted"] as? Bool
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
    
}
