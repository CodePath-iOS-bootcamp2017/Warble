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
    
    var authorizationUrl: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLoginButtonTapped(_ sender: Any) {
        self.startLogin(sender)
    }
    
    func startLogin(_ sender: Any){
        self.setupCallbacks()

        TwitterClient.sharedInstance?.getRequestToken(success: { (requestToken: BDBOAuth1Credential) in
            if let oauth_token = requestToken.token{
                if let authorizeUrl = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(oauth_token)"){
                    self.authorizationUrl = authorizeUrl
                    self.performSegue(withIdentifier: "authorizationSegue", sender: sender)
                }else{
                    print("Can't open web view! Invalid authorization url.")
                }
            }
        }, failure: { (error: Error) in
            print("Error fetching request token: \(error.localizedDescription)")
        })
    }
    
    func setupCallbacks(){
        TwitterClient.sharedInstance?.setupLoginCallbacks(success: {
            self.performSegue(withIdentifier: "successfulLoginSegue", sender: self)
            TwitterClient.sharedInstance?.getCurrentAccountDetails(success: { (user: User) in
                User.currentUser = user
            }, failure: { (error: Error) in
                print("Error the user account details: \(error.localizedDescription)")
            })
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "authorizationSegue"{
            if let vc = segue.destination as? AuthorizationViewController{
                vc.authorizationUrl = self.authorizationUrl
            }
        }
        
    }
    

}
