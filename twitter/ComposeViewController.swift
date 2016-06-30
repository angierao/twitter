//
//  ComposeViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/28/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate, UIAlertViewDelegate {
    
    let maxChars = 140

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tweetButton: UIButton!
    @IBOutlet weak var charsLeft: UILabel!
    @IBOutlet weak var tweetView: UITextView!
    
    var replyUser: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tweetView.delegate = self
        self.tweetView.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        //CGRect frameRect = composeField.frame
        
        //tweetView = UITextView(frame: CGRect(x: 20, y: 80,
            //width: self.view.frame.size.width - 40, height: 40))
        //self.view.addSubview(tweetView!)
        
        
        if let replyUser = replyUser {
            if replyUser.characters.count > 0 {
                applyPlaceholderStyle(tweetView!, placeholderText: "@\(replyUser) ")
            }
            
        }
        print("tweet")
        print(self.tweetView.text)
        
        //self.tweetView.textColor = UIColor.lightGrayColor()
        
        if let replyUser = replyUser {
            let textLength = maxChars - (replyUser.characters.count + 2)
            charsLeft.text = "\(textLength)"
        }
        else {
            charsLeft.text = "\(maxChars)"
        }
        
        //charsLeft.text = "\(maxChars - (((replyUser?.characters.count)! + 2) ?? 0))"
        
        
        cancelButton.layer.cornerRadius = cancelButton.frame.height/6
        
        tweetButton.backgroundColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0)
        
        tweetButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        cancelButton.backgroundColor = UIColor.whiteColor()
        
        cancelButton.setTitleColor(UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0), forState: UIControlState.Normal)
        
        tweetButton.layer.cornerRadius = tweetButton.frame.height/6
        tweetButton.enabled = false
        
        charsLeft.textColor = .lightGrayColor()
        
    }
    
    func applyPlaceholderStyle(aTextview: UITextView, placeholderText: String)
    {
        // make it look (initially) like a placeholder
        aTextview.textColor = UIColor.lightGrayColor()
        aTextview.text = placeholderText
    }

    @IBAction func onTweet(sender: AnyObject) {
        let tweetText = tweetView.text
        if tweetText.characters.count > 140 {
            let alertController = UIAlertController(title: "Error", message: "Tweet must be 140 characters or less", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                print("Dismiss UIAlertController");
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)

        }
        else if tweetText.characters.count == 0 {
            let alertController = UIAlertController(title: "Error", message: "Tweet cannot be empty", preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                print("Dismiss UIAlertController");
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true, completion:nil)

        }
        
        let dict: NSDictionary = [
            "status": tweetText!
        ]
        
        TwitterClientSM.sharedInstance.newTweet(dict, success: { (tweet: Tweet) in
            print("tweeted")
            self.dismissViewControllerAnimated(true, completion: nil)
        }, failure: { (error: NSError) in
                print(error)
        })
        
    }
    
    func textViewDidChange(textView: UITextView) {
        tweetButton.enabled = true
        let status = textView.text
        let charsLeft = maxChars - status.characters.count
        self.charsLeft.text = "\(charsLeft)"
        self.charsLeft.textColor = charsLeft >= 0 ? .lightGrayColor() : .redColor()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if tweetView.textColor == UIColor.lightGrayColor() {
            //tweetView.text = nil
            tweetView.textColor = UIColor.blackColor()
        }
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
