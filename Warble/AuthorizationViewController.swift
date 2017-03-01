//
//  AuthorizationViewController.swift
//  Warble
//
//  Created by Satyam Jaiswal on 2/28/17.
//  Copyright © 2017 Satyam Jaiswal. All rights reserved.
//

import UIKit

class AuthorizationViewController: UIViewController {

    @IBOutlet weak var authorizationWebView: UIWebView!
    
    var authorizationUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadURL()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Authorization_successful"), object: nil, queue: OperationQueue.main) { (Notification) in
            self.dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadURL(){
        if let url = self.authorizationUrl{
            self.authorizationWebView.loadRequest(URLRequest(url: url))
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
