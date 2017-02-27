//
//  Tweet.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/26/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user:User?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int?
    var favoriteCount: Int?
    var imageUrl: URL?
    
    init(dictionary: NSDictionary){
        if let userDictionary = dictionary.value(forKey: "user") as? NSDictionary{
            self.user = User(dictionary: userDictionary)
        }
        
        if let text = dictionary.value(forKey: "text") as? String{
            self.text = text
        }
        
        // Tue Aug 28 21:16:23 +0000 2012
        if let timestamp = dictionary.value(forKey: "created_at") as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZ YYYY"
            self.timestamp = formatter.date(from: timestamp)
        }
        
        if let retweetCount = dictionary.value(forKey: "retweet_count") as? Int{
            self.retweetCount = retweetCount
        }
        
        if let favoriteCount = dictionary.value(forKey: "favourites_count") as? Int{
            self.favoriteCount = favoriteCount
        }
        
        if let entities = dictionary.value(forKey: "entities") as? NSDictionary{
            if let media = entities.value(forKey: "media") as? NSDictionary{
                if let imageUrlString = media.value(forKey: "media_url_https") as? String{
                    if let imageUrl = URL(string: imageUrlString){
                        self.imageUrl = imageUrl
                    }
                }
            }
        }
    }
    
    class func createTweetArray(dictionaryArray: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        for dictionary in dictionaryArray{
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
}
