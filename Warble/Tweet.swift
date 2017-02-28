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
    var retweetedBy: User?
    var favorited: Bool?
    var retweeted: Bool?
    var id: String?
    
    init(dictionary: NSDictionary){
        
        if let retweetDictionary = dictionary.value(forKey: "retweeted_status") as? NSDictionary{
            if let retweetedByUserDictionary = dictionary.value(forKey: "user") as? NSDictionary{
                self.retweetedBy = User(dictionary: retweetedByUserDictionary)
            }
            
            if let userDictionary = retweetDictionary.value(forKey: "user") as? NSDictionary{
                self.user = User(dictionary: userDictionary)
            }
            
            if let text = retweetDictionary.value(forKey: "text") as? String{
                self.text = text
            }
            
            
            if let retweetCount = retweetDictionary.value(forKey: "retweet_count") as? Int{
                self.retweetCount = retweetCount
            }
            
            if let favoriteCount = retweetDictionary.value(forKey: "favorite_count") as? Int{
                self.favoriteCount = favoriteCount
            }
            
            if let entities = retweetDictionary.value(forKey: "entities") as? NSDictionary{
                if let media = entities.value(forKey: "media") as? NSDictionary{
                    if let imageUrlString = media.value(forKey: "media_url_https") as? String{
                        if let imageUrl = URL(string: imageUrlString){
                            self.imageUrl = imageUrl
                        }
                    }
                }
            }
            
        }else{
            if let userDictionary = dictionary.value(forKey: "user") as? NSDictionary{
                self.user = User(dictionary: userDictionary)
            }
            
            if let text = dictionary.value(forKey: "text") as? String{
                self.text = text
            }
            
            if let retweetCount = dictionary.value(forKey: "retweet_count") as? Int{
                self.retweetCount = retweetCount
            }
            
            if let favoriteCount = dictionary.value(forKey: "favorite_count") as? Int{
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
        
        // Tue Aug 28 21:16:23 +0000 2012
        if let timestamp = dictionary.value(forKey: "created_at") as? String{
            let formatter = DateFormatter()
//            formatter.dateFormat = "EEE MMM dd HH:mm:ss ZZZ YYYY"
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            self.timestamp = formatter.date(from: timestamp)
        }
        
        
        if let retweeted = dictionary.value(forKey: "retweeted") as? Bool{
            self.retweeted = retweeted
        }
        
        if let favorited = dictionary.value(forKey: "favorited") as? Bool{
            self.favorited = favorited
        }
        
        if let tweetId = dictionary.value(forKey: "id_str") as? String{
            self.id = tweetId
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
