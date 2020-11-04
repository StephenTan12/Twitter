//
//  LoginViewController.swift
//  
//
//  Created by Stephen Tan on 10/29/20.
//

import UIKit

class LoginViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // do something after page shows up
        
        // checks whether the user was previously logged in and didn't log out
        if UserDefaults.standard.bool(forKey: "userLoggedIn") {
            
            // performs the segue to the next screen
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        // user authentication and login thru Twitter API
        TwitterAPICaller.client?.login(url: myUrl, success: {
            // setting userdefault so that user will not have to login if user doesn't log out
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }, failure: { (Error) in
            print("Could not login")
        })
    }
}
