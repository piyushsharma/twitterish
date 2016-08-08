//
//  HamburgerViewController.swift
//  Twitter
//
//  Created by Piyush Sharma on 8/5/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var contentViewleftMC: NSLayoutConstraint!
    
    var contentViewOriginalLeftMC: CGFloat!
    
    var menuViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if (oldContentViewController != nil) {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            menuViewController.willMoveToParentViewController(self)
            menuView.addSubview(menuViewController.view)
            menuViewController.didMoveToParentViewController(self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController) {
            view.layoutIfNeeded()
            
            if (oldContentViewController != nil) {
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            
            contentViewController.willMoveToParentViewController(self)
            contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            
            UIView.animateWithDuration(0.3) { 
                self.contentViewleftMC.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        
        if sender.state == UIGestureRecognizerState.Began {
            
            contentViewOriginalLeftMC = contentViewleftMC.constant
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            contentViewleftMC.constant = contentViewOriginalLeftMC + translation.x 
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.3, animations: {
                if velocity.x > 0 {
                    self.contentViewleftMC.constant = self.view.frame.size.width - 50
                } else {
                    self.contentViewleftMC.constant = 0
                }
                self.view.layoutIfNeeded()
            })
        }
        
        
        
        
        
    }
}
