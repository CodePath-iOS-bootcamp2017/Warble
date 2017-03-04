//
//  ProfileViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 3/4/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followerCountLabel: UILabel!
    @IBOutlet weak var profileTableview: UITableView!
    
    var user: User?
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupUI(){
        self.configureShowingUser()
        self.setupTableView()
        self.loadUserTweets()
    }
    
    func setupTableView(){
        self.profileTableview.delegate = self
        self.profileTableview.dataSource = self
        self.profileTableview.estimatedRowHeight = 120
        self.profileTableview.rowHeight = UITableViewAutomaticDimension
    }
    
    func configureShowingUser(){
        var showingUser: User?
        if let user = User.currentUser{
            showingUser = user
        }
        
        if let user = self.user{
            showingUser = user
        }else{
            self.user = User.currentUser
        }
        
        if let user = showingUser{
            if let bannerUrl = user.backgroundImageUrl{
                self.coverImageView.setImageWith(bannerUrl)
            }
            
            if let profileImageUrl = user.profileImageUrl{
                self.profileImageView.setImageWith(profileImageUrl)
                self.profileImageView.layer.cornerRadius = 10
                self.profileImageView.layer.masksToBounds = true
            }
            
            if let name = user.name{
                self.nameLabel.text = name
            }
            
            if let handle = user.handle{
                self.handleLabel.text = handle
            }
            
            if let tweetCount = user.statusesCount{
                self.tweetCountLabel.text = "\(tweetCount)"
            }
            
            if let followingCount = user.followersCount{
                self.followingCountLabel.text = "\(followingCount)"
            }
            
            if let followerCount = user.followersCount{
                self.followerCountLabel.text = "\(followerCount)"
            }
        }
    }
    
    func loadUserTweets(){
        if let userId = self.user?.id{
            TwitterClient.sharedInstance?.getUserTimelineTweets(id: userId, success: { (dictionaryArr: [NSDictionary]) in
                self.tweets = Tweet.createTweetArray(dictionaryArray: dictionaryArr)
                self.profileTableview.reloadData()
            }, failure: { (error: Error) in
                print("Error getting user tweets: \(error.localizedDescription)")
            })
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets == nil{
            return 0
        }else{
            return (self.tweets?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileTableCell", for: indexPath) as! HomeTableViewCell
        cell.tweet = self.tweets?[indexPath.row]
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
