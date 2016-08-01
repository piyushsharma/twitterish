//
//  ComposeViewController.swift
//  Twitter
//
//  Created by Piyush Sharma on 7/31/16.
//  Copyright © 2016 Piyush Sharma. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var composeTextView: UITextView!
    
    let maxCharacters = 140
    
    var characterRemainingButtonLabel = UIBarButtonItem(title: "140", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composeTextView.delegate = self
        
        composeTextView.text = "What's happening?"
        composeTextView.textColor = UIColor.lightGrayColor()
        
        composeTextView.becomeFirstResponder()
        composeTextView.selectedTextRange = composeTextView.textRangeFromPosition(composeTextView.beginningOfDocument, toPosition: composeTextView.beginningOfDocument)

        
        let imageUrl = User.currentUser?.profileUrl
        if let imageUrl = imageUrl {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.setImageWithURL(imageUrl)
            imageView.contentMode = .ScaleAspectFit
            navigationItem.titleView = imageView
        }
        
        self.addDoneButtonOnKeyboard()        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onCancelButton(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func addDoneButtonOnKeyboard() {
        
        let tweetToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        tweetToolbar.barStyle = UIBarStyle.Default

        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let tweetButton = UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.Done, target: self,
                                                           action: #selector(ComposeViewController.tweetButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(self.characterRemainingButtonLabel)
        items.append(flexSpace)
        items.append(tweetButton)
        
        tweetToolbar.items = items
        tweetToolbar.sizeToFit()
        
        self.composeTextView.inputAccessoryView = tweetToolbar
    }

    
    
    func tweetButtonAction() {
        self.composeTextView.resignFirstResponder()
        
        let tweetText = self.composeTextView.text
        
        if tweetText.characters.count == 0 {
            return
        }
        
        let params: NSDictionary = [
            "status": tweetText
        ]
        
        TwitterClient.sharedInstance.postTweet(params) { (tweet, error) in
            if (tweet != nil) {
                
                NSNotificationCenter.defaultCenter().postNotificationName(Tweet.userComposedNewTweet, object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
                
            } else {
                NSLog("error posting tweet: \(error)")
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        let charactersRemaining = maxCharacters - textView.text.characters.count
        self.characterRemainingButtonLabel.title = "\(charactersRemaining)"
    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            self.characterRemainingButtonLabel.title = "\(maxCharacters)"
            textView.text = "What's happening?"
            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    
    func textViewDidChangeSelection(textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGrayColor() {
                textView.selectedTextRange = textView.textRangeFromPosition(
                    textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            }
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
