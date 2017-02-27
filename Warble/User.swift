//
//  User.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/26/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var handle: String?
    var followersCount: Int?
    var backgroundImageUrl: URL?
    var statusesCount: Int?
    var profileImageUrl: URL?
    var id: String?
    var bio: String?
    var userDictionary: NSDictionary?
    
    static var _currentUser: User?
    
    class var currentUser: User?{
        get{
            if(_currentUser == nil){
                
                let defaults = UserDefaults.standard
//                defaults.removeObject(forKey: "currentUserData")
                let data = defaults.object(forKey: "currentUserData") as? Data
                if let data = data{
                    if let currentUserDictionary = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary{
                        let user = User(dictionary: currentUserDictionary)
                        self._currentUser = user
                    }
                }
            }
            return _currentUser
        }
        set(user){
            _currentUser = user
            let defaults = UserDefaults.standard
            if let user = user{
                let data = try! JSONSerialization.data(withJSONObject: user.userDictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            }else{
                defaults.removeObject(forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    
    init(dictionary: NSDictionary) {
        self.userDictionary = dictionary
        
        if let name = dictionary.value(forKey: "name") as? String{
            self.name = name
        }
        
        if let handle = dictionary.value(forKey: "screen_name") as? String{
            self.handle = handle
        }
        
        if let followersCount = dictionary.value(forKey: "followers_count") as? Int{
            self.followersCount = followersCount
        }
        
        if let backgroundImageUrlString = dictionary.value(forKey: "profile_banner_url") as? String{
            if let backgroundImageUrl = URL(string: backgroundImageUrlString){
                self.backgroundImageUrl = backgroundImageUrl
            }
        }
        
        if let statusesCount = dictionary.value(forKey: "statuses_count") as? Int{
            self.statusesCount = statusesCount
        }
        
        if let profileImageUrlString = dictionary.value(forKey: "profile_image_url_https") as? String{
            if let profileImageUrl = URL(string: profileImageUrlString){
                self.profileImageUrl = profileImageUrl
            }
        }
        
        if let id = dictionary.value(forKey: "id_str") as? String{
            self.id = id
        }
        
        if let bio = dictionary.value(forKey: "description") as? String{
            self.bio = bio
        }
        
    }
}
