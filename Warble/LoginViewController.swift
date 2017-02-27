//
//  LoginViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/21/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit
import AFNetworking
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        TwitterClient.sharedInstance?.loginToTwitter(success: {
            self.performSegue(withIdentifier: "successfulLoginSegue", sender: self)
            TwitterClient.sharedInstance?.getCurrentAccountDetails(success: { (user: User) in
                User.currentUser = user
            }, failure: { (error: Error) in
                print("Error the user account details: \(error.localizedDescription)")
            })
        }, failure: { (error: Error) in
            print("Error logging to twitter: \(error.localizedDescription)")
        })
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
