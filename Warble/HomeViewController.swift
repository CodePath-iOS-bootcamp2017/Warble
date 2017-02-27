//
//  HomeViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/21/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadFromNetwork()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadFromNetwork(){
        TwitterClient.sharedInstance?.getHomeTimelineTweets(success: { (tweets: [NSDictionary]) in
            print(tweets)
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
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
