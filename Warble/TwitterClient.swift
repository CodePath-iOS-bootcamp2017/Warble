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
    
    func loginToTwitter(success: @escaping ()->Void, failure: @escaping (Error)->Void){
        successfulLogin = success
        failedLogin = failure
        
        TwitterClient.sharedInstance?.deauthorize()
        
        print("Fetching request token...")
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "warble://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("Got request token!")
            if let oauth_token = requestToken?.token{
                if let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(oauth_token)"){
                    UIApplication.shared.open(authorizeUrl , options: [:], completionHandler: { (isSuccessful: Bool) in
                        print("Launched mobile safari for user authorization!")
                    })
                }else{
                    print("Can't open mobile safari! Invalid authorization url.")
                }
            }
        }, failure: { (error: Error?) in
            print("Error fetching request token: \(error.debugDescription)")
        })
    }
    
    func handleUrl(url: URL){
        print("User authorization successful")
        
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
}
