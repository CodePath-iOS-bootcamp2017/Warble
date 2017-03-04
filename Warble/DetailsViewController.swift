//
//  DetailsViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/28/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var enclosingScrollView: UIScrollView!
    @IBOutlet weak var retweetedByImageView: UIImageView!
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var messageImageView: UIImageView!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var bottomMostView: UIView!
    
    var tweet: Tweet?
    var sourceRowNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.configureGestureRecognizers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setScrollViewContentSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupScrollView(){
        self.enclosingScrollView.delegate = self
        self.setScrollViewContentSize()
    }
    
    func setScrollViewContentSize(){
        let contentWidth = self.enclosingScrollView.bounds.width
        let contentHeight = self.bottomMostView.frame.maxY + 100.0
//        print(contentHeight)
        self.enclosingScrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
    }
    
    func setupUI(){
        self.setupScrollView()
        self.setupNavigationBar()
        
        if let retweetedBy = self.tweet?.retweetedBy{
            self.retweetedByLabel.isHidden = false
            self.retweetedByImageView.isHidden = false
            self.retweetedByLabel.text = "\(retweetedBy.name) retweeted"
        }else{
            self.retweetedByLabel.isHidden = true
            self.retweetedByImageView.isHidden = true
        }
        
        if let name = self.tweet?.user?.name{
            self.nameLabel.text = name
        }
        
        if let handle = self.tweet?.user?.handle{
            self.handleLabel.text = "@\(handle)"
        }
        
        if let profileImageUrl = self.tweet?.user?.profileImageUrl{
            self.profileImageView.setImageWith(profileImageUrl)
            self.profileImageView.layer.cornerRadius = 10
            self.profileImageView.layer.masksToBounds = true
        }
        
        if let text = self.tweet?.text{
            self.textLabel.text = text
        }
        
        if let mediaUrl = self.tweet?.imageUrl{
            self.mediaImageView.isHidden = false
            self.mediaImageView.setImageWith(mediaUrl)
        }else{
            self.mediaImageView.isHidden = true
        }
        
        if let timestamp = self.tweet?.timestamp{
            
            var timestampText = ""
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateStyle = .none
            timeFormatter.timeStyle = .short
            timestampText.append(timeFormatter.string(from: timestamp))
            
            timestampText.append(" • ")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            timestampText.append(dateFormatter.string(from: timestamp))

            self.timestampLabel.text = timestampText
        }
        
        if let retweetsCount = self.tweet?.retweetCount{
            self.retweetCountLabel.text = "\(retweetsCount)"
        }
        
        if let favoriteCount = self.tweet?.favoriteCount{
            self.favoriteCountLabel.text = "\(favoriteCount)"
        }
        
        if let favorited = self.tweet?.favorited{
            if favorited{
                self.favoriteImageView.image = UIImage(named: "favor-icon-red")
            }else{
                self.favoriteImageView.image = UIImage(named: "favor-icon-gray")
            }
        }
        
        if let retweeted = self.tweet?.retweeted{
            if retweeted{
                self.retweetImageView.image = UIImage(named: "retweet-icon-green")
            }else{
                self.retweetImageView.image = UIImage(named: "retweet-icon")
            }
        }

    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        print("didRotate")
        self.setScrollViewContentSize()
    }
    
    func setupNavigationBar(){
        
        navigationController?.delegate = self
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func configureGestureRecognizers(){
        let favoriteTapped = UITapGestureRecognizer()
        favoriteTapped.addTarget(self, action: #selector(onFavoriteTapped))
        self.favoriteImageView.addGestureRecognizer(favoriteTapped)
        self.favoriteImageView.isUserInteractionEnabled = true
        
        let retweetedTapped = UITapGestureRecognizer()
        retweetedTapped.addTarget(self, action: #selector(onRetweetTapped))
        self.retweetImageView.addGestureRecognizer(retweetedTapped)
        self.retweetImageView.isUserInteractionEnabled = true
    }
    
    func onFavoriteTapped(_ sender: AnyObject){
//        print("onFavoriteTapped")
        if let favorited = self.tweet?.favorited{
            if favorited{
                TwitterClient.sharedInstance?.destroyFavorites(id: (self.tweet?.id)!, success: { (dictionary: NSDictionary) in
                    print("favorite destroyed: \((self.tweet?.id)!)")
                    self.tweet?.favorited = false
                    self.favoriteImageView.image = UIImage(named: "favor-icon-gray")
                }, failure: { (error: Error) in
                    print("Error destorying favorite: \(error.localizedDescription)")
                })
                
            }else{
                TwitterClient.sharedInstance?.createFavorites(id: (self.tweet?.id)!, success: { (dictionary: NSDictionary) in
                    print("favorite created: \((self.tweet?.id)!)")
                    self.tweet?.favorited = true
                    self.favoriteImageView.image = UIImage(named: "favor-icon-red")
                }, failure: { (error: Error) in
                    print("Error creating favorite: \(error.localizedDescription)")
                })
            }
        }
    }
    
    func onRetweetTapped(_ sender: Any){
        if let retweeted = self.tweet?.retweeted{
            if retweeted{
                TwitterClient.sharedInstance?.unretweet(id: (self.tweet?.id)!, success: { (dictionary: NSDictionary) in
                    print("retweet destroyed: \((self.tweet?.id)!)")
                    self.tweet?.retweeted = false
                    self.retweetImageView.image = UIImage(named: "retweet-icon")
                }, failure: { (error: Error) in
                    print("Error destroying retweeted: \(error.localizedDescription)")
                })
                
            }else{
                TwitterClient.sharedInstance?.retweet(id: (self.tweet?.id)!, success: { (dictionary: NSDictionary) in
                    print("retweet created: \((self.tweet?.id)!)")
                    self.tweet?.retweeted = true
                    self.retweetImageView.image = UIImage(named: "retweet-icon-green")
                }, failure: { (error: Error) in
                    print("Error creating retweet: \(error.localizedDescription)")
                })
                
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let vc = viewController as? HomeViewController{
            if let row = self.sourceRowNumber{
                vc.tweets?[row] = self.tweet!
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
