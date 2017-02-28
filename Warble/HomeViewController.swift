//
//  HomeViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/21/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var homeTableView: UITableView!
    
    var tweets:[Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFromNetwork()
        self.setupHomeTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupHomeTableView(){
        self.homeTableView.delegate = self
        self.homeTableView.dataSource = self
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.estimatedRowHeight = 120
    }
    
    func loadFromNetwork(){
        TwitterClient.sharedInstance?.getHomeTimelineTweets(success: { (tweets: [NSDictionary]) in
            // print(tweets)
            self.tweets = Tweet.createTweetArray(dictionaryArray: tweets)
//            for tweet in self.tweets!{
//                print(tweet.text)
//            }
            self.homeTableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tweets == nil{
            return 0
        }else{
            return (self.tweets?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.tweet = self.tweets?[indexPath.row]
        return cell
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        TwitterClient.sharedInstance?.logoutCurrentUser()
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
