//
//  HomeViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/21/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CellDelegate {

    
    @IBOutlet weak var homeTableView: UITableView!
    
    var tweets:[Tweet]?
    var isLoadingMoreData = false
    var loadingMoreProgressIndicator = InfiniteScrollActivityView()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFromNetwork()
        self.setupHomeTableView()
        self.configureInfiniteLoadProgressIndicator()
        self.configureRehreshControl()
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
    
    func configureInfiniteLoadProgressIndicator(){
        let progressIndicatorFrameTableView = CGRect(x: 0, y: self.homeTableView.contentSize.height, width: self.homeTableView.bounds.width, height: InfiniteScrollActivityView.defaultHeight)
        self.loadingMoreProgressIndicator = InfiniteScrollActivityView(frame: progressIndicatorFrameTableView)
        loadingMoreProgressIndicator.isHidden = true
        
        self.homeTableView.addSubview(loadingMoreProgressIndicator)
        
        var insetTableView = self.homeTableView.contentInset
        insetTableView.bottom += (loadingMoreProgressIndicator.bounds.height)
        self.homeTableView.contentInset = insetTableView
    }
    
    func configureRehreshControl(){
        self.refreshControl.addTarget(self, action: #selector(refreshContent(_:)), for: UIControlEvents.valueChanged)
        self.refreshControl.tintColor = UIColor.blue
        self.homeTableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshContent(_ refreshControl: UIRefreshControl){
        self.loadFromNetwork()
        refreshControl.endRefreshing()
    }
    
    func loadFromNetwork(){
        TwitterClient.sharedInstance?.getHomeTimelineTweets(success: { (tweets: [NSDictionary]) in
//             print(tweets)
            self.tweets = Tweet.createTweetArray(dictionaryArray: tweets)
//            for tweet in self.tweets!{
//                print(tweet.text)
//            }
            self.homeTableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    
    func loadMoreTweets(){
        if let tweetsCollection =  self.tweets{
            TwitterClient.sharedInstance?.getHomeTimelineTweetsBefore(id: (tweetsCollection.last?.id)!, success: { (moreTweets: [NSDictionary]) in
                self.tweets?.append(contentsOf: Tweet.createTweetArray(dictionaryArray: moreTweets))
                self.homeTableView.reloadData()
                self.isLoadingMoreData = false
                self.loadingMoreProgressIndicator.stopAnimating()
                
            }, failure: { (error: Error) in
                print("Error loading more tweets: \(error.localizedDescription)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        cell.tweet = self.tweets?[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.isLoadingMoreData{
            let totalHeight = self.homeTableView.contentSize.height
            let tableHeight = self.homeTableView.bounds.height
            let threshold = totalHeight - tableHeight
            
            if scrollView.contentOffset.y > threshold && scrollView.isDragging{
                let frame = CGRect(x: 0, y: self.homeTableView.contentSize.height, width: self.homeTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                self.loadingMoreProgressIndicator.frame = frame
                self.loadingMoreProgressIndicator.startAnimating()
                
                isLoadingMoreData = true
                loadMoreTweets()
            }
        }
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        TwitterClient.sharedInstance?.logoutCurrentUser()
    }
    
    func onTapCellLike(_ sender: AnyObject?) {
//        print("onTapCellLike")
        if let recognizer = sender as? UITapGestureRecognizer{
            let imageView = recognizer.view
            if let cellView = imageView?.superview?.superview as? HomeTableViewCell {
                let indexPath = self.homeTableView.indexPath(for: cellView)
                if let row = indexPath?.row{
                    if let tweet = self.tweets?[row]{
//                        print("processing tweet id: \(tweet.id)")
                        if tweet.favorited! {
                            //self.tweets![(indexPath?.row)!].liked = false
                            TwitterClient.sharedInstance?.destroyFavorites(id: tweet.id!, success: { (dictionary: NSDictionary) in
                                self.tweets?[(indexPath?.row)!].favorited = false
                                self.tweets?[(indexPath?.row)!].favoriteCount = (self.tweets?[(indexPath?.row)!].favoriteCount)! - 1
                                self.homeTableView.reloadData()
                            }, failure: { (error: Error) in
                                print(error.localizedDescription)
                            })
                        }else{
                            TwitterClient.sharedInstance?.createFavorites(id: tweet.id!, success: { (dictionary: NSDictionary) in
                                self.tweets?[(indexPath?.row)!].favorited = true
                                self.tweets?[(indexPath?.row)!].favoriteCount = (self.tweets?[(indexPath?.row)!].favoriteCount)! + 1
                                self.homeTableView.reloadData()
                            }, failure: { (error: Error) in
                                print(error.localizedDescription)
                            })
                            
                        }
                    }
                }
            }
        }
    }
    
    func onTapCellRetweet(_ sender: AnyObject?){
        if let recognizer = sender as? UITapGestureRecognizer{
            let imageView = recognizer.view
            if let cellView = imageView?.superview?.superview as? HomeTableViewCell {
                let indexPath = self.homeTableView.indexPath(for: cellView)
                if let row = indexPath?.row{
                    if let tweet = self.tweets?[row]{
                        //                        print("processing tweet id: \(tweet.id)")
                        if tweet.retweeted! {
                            //self.tweets![(indexPath?.row)!].liked = false
                            TwitterClient.sharedInstance?.unretweet(id: tweet.id!, success: { (dictionary: NSDictionary) in
                                self.tweets?[(indexPath?.row)!].retweeted = false
                                self.tweets?[(indexPath?.row)!].retweetCount = (self.tweets?[(indexPath?.row)!].retweetCount)! - 1
                                self.homeTableView.reloadData()
                            }, failure: { (error: Error) in
                                print(error.localizedDescription)
                            })
                        }else{
                            TwitterClient.sharedInstance?.retweet(id: tweet.id!, success: { (dictionary: NSDictionary) in
                                self.tweets?[(indexPath?.row)!].retweeted = true
                                self.tweets?[(indexPath?.row)!].retweetCount = (self.tweets?[(indexPath?.row)!].retweetCount)! + 1
                                self.homeTableView.reloadData()
                            }, failure: { (error: Error) in
                                print(error.localizedDescription)
                            })
                            
                        }
                    }
                }
            }
        }
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
