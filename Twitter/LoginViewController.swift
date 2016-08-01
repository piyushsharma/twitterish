 //
//  LoginViewController.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/27/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.setBackgroundImage(UIImage(named: "t_launch.png"), forState: .Normal)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLoginButton(sender: AnyObject) {
        TwitterClient.sharedInstance.login({
            
            NSLog("Log in success")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
            
        }) { (error: NSError) -> () in
            print(error.localizedDescription)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
