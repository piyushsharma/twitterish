//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Piyush Sharma on 8/5/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //TweetsNavigationController
    private var tweetNavigationController: UIViewController!
    //ProfileViewController
    private var profileNavigationController: UIViewController!
    
    let titles = ["Home", "Profile", "Notifications", "Privacy and Safety", "About Twitter"]
    
    var viewControllers: [UIViewController] = []
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        tweetNavigationController = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
        profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileViewNavigationController")
        
        viewControllers.append(tweetNavigationController)
        viewControllers.append(profileNavigationController)
        
        hamburgerViewController.contentViewController = tweetNavigationController
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 63.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        
        
        cell.menuLabel.text = titles[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == 1 {
            hamburgerViewController.contentViewController = viewControllers[indexPath.row]
        } else {
            hamburgerViewController.contentViewController = viewControllers[0]
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
