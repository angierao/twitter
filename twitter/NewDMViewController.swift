//
//  NewDMViewController.swift
//  twitter
//
//  Created by Angeline Rao on 7/1/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class NewDMViewController: UIViewController {

    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var twitterNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var toField: UITextField!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        sendButton.layer.cornerRadius = sendButton.frame.height/12
        let user = User.currentUser
        nameLabel.text = user?.name as! String
        twitterNameLabel.text = user?.screenname as! String
        
        let imageRequest = NSURLRequest(URL: user!.profileUrl!)
        
        profPicView.setImageWithURLRequest(imageRequest, placeholderImage: UIImage(named: "defaulttwitter"), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            self.profPicView.image = image
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            print(error)
        }
        profPicView.layer.cornerRadius = profPicView.frame.height/12

        // Do any additional setup after loading the view.
    }
    
   

    @IBAction func onSend(sender: AnyObject) {
        
        let dict: NSDictionary = [
            "screen_name": toField.text!,
            "text": messageView.text
        ]
        TwitterClientSM.sharedInstance.newMessage(dict, success: { (message: Message) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error: NSError) in
                print(error)
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
