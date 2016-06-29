//
//  DetailViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/28/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var tweet: Tweet?
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterName: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var RTLabel: UILabel!
    @IBOutlet weak var faveLabel: UILabel!

    @IBOutlet weak var RTButton: UIButton!
    @IBOutlet weak var faveButton: UIButton!
    
    //var tweet: Tweet! {
        //didSet
    //}

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
                let user: User = tweet!.author!
                nameLabel.text = user.name as? String
                let twitterNameString = user.screenname as! String
                twitterName.text = "@\(twitterNameString)"
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MMM d, h:mm a"
                let dateString = dateFormatter.stringFromDate(tweet!.timestamp!)
                timeLabel.text = dateString
                
                tweetLabel.text = tweet!.text as? String
                
                RTLabel.text = "\(tweet!.RTs) RETWEETS"
                
                faveLabel.text = "\(tweet!.faves) LIKES"
                
                let imageRequest = NSURLRequest(URL: user.profileUrl!)
                
                profPicView.setImageWithURLRequest(imageRequest, placeholderImage: UIImage(named: "defaulttwitter"), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
                    self.profPicView.image = image
                }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
                    print(error)
                }
        
        
        
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
