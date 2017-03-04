//
//  TwitterClient.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/25/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com/"), consumerKey: "bO8FUoGIslOG8J5Wov5iEgcjE", consumerSecret: "PSeAUq8rS85lSlEXjiVelWRAnTXN4aUoX9D6HIMtc7zgInaMXL")
    var successfulLogin: (() -> Void)?
    var failedLogin: ((Error) -> Void)?
    
    func getRequestToken(success: @escaping (BDBOAuth1Credential) -> Void, failure: @escaping (Error) -> Void){
        print("Fetching request token...")
        TwitterClient.sharedInstance?.deauthorize()
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "warble://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("Got request token!")
            success(requestToken!)
        }, failure: { (error: Error?) in
            failure(error!)
        })
    }
    
    func setupLoginCallbacks(success: @escaping ()->Void, failure: @escaping (Error)->Void){
        self.successfulLogin = success
        self.failedLogin = failure
    }
    
    func handleUrl(url: URL){
        print("User authorization successful!")
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        print("Fetching access token...")
        TwitterClient.sharedInstance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken:BDBOAuth1Credential?) in
            print("Got access token!")
            self.successfulLogin?()
        }, failure: { (error: Error?) in
            if let error = error{
                print("error fetching access token: \(error.localizedDescription)")
                self.failedLogin?(error)
            }
        })
    }
    
    func getHomeTimelineTweets(success:@escaping (_ response: [NSDictionary])->Void, failure: @escaping (_ error: Error) -> Void){
        TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
//            print(task.debugDescription)
            if let tweets = response as? [NSDictionary]{
                success(tweets)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getHomeTimelineTweetsBefore(id: String, success:@escaping (_ response: [NSDictionary])->Void, failure: @escaping (_ error: Error) -> Void){
        let parameters: [String: Any] = ["max_id": id as Any]
        TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //            print(task.debugDescription)
            if let tweets = response as? [NSDictionary]{
                success(tweets)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getHomeTimelineTweetsAfter(id: String, success:@escaping (_ response: [NSDictionary])->Void, failure: @escaping (_ error: Error) -> Void){
        let parameters: [String: Any] = ["since_id": id as Any]
        TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //            print(task.debugDescription)
            if let tweets = response as? [NSDictionary]{
                success(tweets)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getUserTimelineTweets(id: String, success:@escaping (_ response: [NSDictionary])->Void, failure: @escaping (_ error: Error) -> Void){
        let parameters: [String: Any] = ["id": id as Any]
        TwitterClient.sharedInstance?.get("1.1/statuses/user_timeline.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            //            print(task.debugDescription)
            if let tweets = response as? [NSDictionary]{
                success(tweets)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getCurrentAccountDetails(success: @escaping (User) -> Void, failure: @escaping (Error)->Void){
         TwitterClient.sharedInstance?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
         if let res = response as? NSDictionary{
//            print(res)
            let user = User(dictionary: res)
            success(user)
         }
         }, failure: { (task: URLSessionDataTask?, error: Error) in
//            print(error.localizedDescription)
            failure(error)
         })
    }
    
    func retweet(id: String, success:@escaping (_ response: NSDictionary)->Void, failure: @escaping (_ error: Error) -> Void){
        let parameters: [String: Any] = ["id": id as Any]
        TwitterClient.sharedInstance?.post("1.1/statuses/retweet.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweet = response as? NSDictionary{
                success(tweet)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func unretweet(id: String, success:@escaping (_ response: NSDictionary)->Void, failure: @escaping (_ error: Error) -> Void){
        let parameters: [String: Any] = ["id": id as Any]
        TwitterClient.sharedInstance?.post("1.1/statuses/unretweet.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweet = response as? NSDictionary{
                success(tweet)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func createFavorites(id: String, success:@escaping (_ response: NSDictionary)->Void, failure: @escaping (_ error: Error) -> Void){
        let parameters: [String: Any] = ["id": id]
//        print(parameters)
        TwitterClient.sharedInstance?.post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweet = response as? NSDictionary{
                success(tweet)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    
    func destroyFavorites(id: String, success:@escaping (_ response: NSDictionary)->Void, failure: @escaping (_ error: Error) -> Void){
        let parameters: [String: Any] = ["id": id as Any]
        TwitterClient.sharedInstance?.post("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweet = response as? NSDictionary{
                success(tweet)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func getStatus(id: String, success:@escaping (_ response: NSDictionary)->Void, failure: @escaping (_ error: Error) -> Void){
        let parameters: [String: Any] = ["id": id as Any]
        print(parameters)
        TwitterClient.sharedInstance?.get("1.1/statuses/show.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let tweet = response as? NSDictionary{
                success(tweet)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func logoutCurrentUser(){
        User.currentUser = nil
        TwitterClient.sharedInstance?.deauthorize()
        print("User successfully logged out")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "User_Logged_out"), object: nil)
    }
}
