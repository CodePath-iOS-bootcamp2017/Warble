//
//  ProfileViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 3/4/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configureRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCloseTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureRefreshControl(){
        self.refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        self.profileTableview.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl){
        self.loadUserTweets()
        refreshControl.endRefreshing()
    }
    
    func setupUI(){
        self.configureShowingUser()
        self.setupTableView()
        self.loadUserTweets()
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)
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
            self.addLogoutButton()
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
                self.handleLabel.text = "@\(handle)"
            }
            
            if let tweetCount = user.statusesCount{
                self.tweetCountLabel.text = self.formatNumber(number: tweetCount)
            }
            
            if let followingCount = user.followingCount{
                self.followingCountLabel.text = self.formatNumber(number: followingCount)
            }
            
            if let followerCount = user.followersCount{
                self.followerCountLabel.text = self.formatNumber(number: followerCount)
            }
        }
    }
    
    func addLogoutButton(){
        
        let logoutButton = UIButton()
        logoutButton.setTitle("logout", for: UIControlState.normal)
        logoutButton.frame = CGRect(x: 0, y: 0, width: 80, height: 25)
        logoutButton.addTarget(self, action: #selector(onLogoutTapped(_:)), for: UIControlEvents.touchDown)
        logoutButton.isUserInteractionEnabled = true
        
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = logoutButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func formatNumber(number: Int) -> String{
        if number >= 1000000 {
            let million = Float(number)/1000000
            return String(format: "%.1f M", million)
        }else if number >= 1000{
            let grand = Float(number)/1000
            return String(format: "%.1f K", grand)
        }else{
            return "\(number)"
        }
    }
    
    func loadUserTweets(){
        if let userId = self.user?.id{
            SVProgressHUD.show()
            TwitterClient.sharedInstance?.getUserTimelineTweets(id: userId, success: { (dictionaryArr: [NSDictionary]) in
                self.tweets = Tweet.createTweetArray(dictionaryArray: dictionaryArr)
                self.profileTableview.reloadData()
                SVProgressHUD.dismiss()
            }, failure: { (error: Error) in
                print("Error getting user tweets: \(error.localizedDescription)")
                SVProgressHUD.dismiss()
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func onLogoutTapped(_ sender: Any) {
        TwitterClient.sharedInstance?.logoutCurrentUser()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //showDetailsSegue
        if segue.identifier == "showDetailsSegue" {
            let cell = sender as! HomeTableViewCell
            let index = self.profileTableview.indexPath(for: cell)
            
            let vc = segue.destination as! DetailsViewController
            vc.tweet = self.tweets?[(index?.row)!]
            vc.sourceRowNumber = index?.row
        }
        
    }
    

}
