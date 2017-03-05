//
//  ComposeViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 3/4/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

protocol ComposeTweetDelegate{
    func onNewTweet(status: Tweet)
}

class ComposeViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var statusTextView: UITextView!
    
    let characterCountLabel = UILabel()
    
    var recepientTweetId: String?
    var recepientUser: User?
    var delegate: ComposeTweetDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        navigationController?.delegate = self
        self.setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        self.setupTextView()
        
        if let user = User.currentUser{
            if let name = user.name{
                self.nameLabel.text = name
            }
            
            if let handle = user.handle{
                self.handleLabel.text = handle
            }
            
            if let profileImageUrl = user.profileImageUrl{
                self.profileImageView.setImageWith(profileImageUrl)
                self.profileImageView.layer.cornerRadius = 5
                self.profileImageView.layer.masksToBounds = true
            }
        }
    }
    
    func setupTextView(){
        self.statusTextView.delegate = self
        if let recepient = self.recepientUser{
            if let recepientHandle = recepient.handle{
                self.statusTextView.text = "@\(recepientHandle) "
            }
        }else{
            self.statusTextView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let characterleft = 140 - NSString(string: textView.text).length
        self.characterCountLabel.text = "\(characterleft)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return NSString(string: textView.text).length + (NSString(string: text).length - range.length) <= 140
    }

    @IBAction func onCancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupNavigationBar(){

        navigationController?.navigationBar.barTintColor = UIColor(red: 0.3, green: 0.5, blue: 0.8, alpha: 1.0)
        
        let customView = UIView()
        customView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        
        
        self.characterCountLabel.frame = CGRect(x: 0, y: 0, width: 30, height: 25)
        self.characterCountLabel.text = "140"
        customView.addSubview(characterCountLabel)

        let tweetButton = UIButton()
        tweetButton.setTitle("Tweet", for: UIControlState.normal)
        tweetButton.frame = CGRect(x: 45, y: 0, width: 50, height: 25)
        tweetButton.addTarget(self, action: #selector(onTweetTapped(_:)), for: UIControlEvents.touchDown)
        tweetButton.isUserInteractionEnabled = true
        customView.addSubview(tweetButton)
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = customView
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    @IBAction func onTapBackground(_ sender: Any) {
        self.statusTextView.resignFirstResponder()
    }
    
    func onTweetTapped(_ sender: Any){
        print("tweet tapped")
        
        if let statusText = self.statusTextView.text{
            if !statusText.isEmpty{
                if let statusId = self.recepientTweetId{
                    TwitterClient.sharedInstance?.replyToStatus(status: statusText, id: statusId, success: { (dictionary:NSDictionary) in
                        self.delegate?.onNewTweet(status: Tweet(dictionary: dictionary))
                        self.dismiss(animated: true, completion: nil)
                    }, failure: { (error: Error) in
                        print("Error on replying to tweet: \(error.localizedDescription)")
                    })
                }else{
                    TwitterClient.sharedInstance?.composeNewTweet(status: statusText, success: { (dictionary: NSDictionary) in
                        self.delegate?.onNewTweet(status: Tweet(dictionary: dictionary))
                        self.dismiss(animated: true, completion: nil)
                    }, failure: { (error: Error) in
                        print("Error on posting new tweet: \(error.localizedDescription)")
                    })
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
