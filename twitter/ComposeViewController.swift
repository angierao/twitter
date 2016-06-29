//
//  ComposeViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/28/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    @IBOutlet weak var composeField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //CGRect frameRect = composeField.frame
        composeField.frame = CGRect()
        composeField.frame.size.height = 100 // <-- Specify the height you want here.
    }

    @IBAction func onTweet(sender: AnyObject) {
        let tweetText = composeField.text
        let dict: NSDictionary = [
            "status": tweetText!
        ]
        
        TwitterClientSM.sharedInstance.newTweet(dict, success: { (tweet: Tweet) in
            print("tweeted")
            self.dismissViewControllerAnimated(true, completion: { 
                print("vc dismissed")
            })
        }, failure: { (error: NSError) in
                print(error)
        })
        
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
