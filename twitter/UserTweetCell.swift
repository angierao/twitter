//
//  UserTweetCell.swift
//  twitter
//
//  Created by Angeline Rao on 6/29/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class UserTweetCell: UITableViewCell {
    //var tweet: Tweet?
    
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var twitterNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var faveButton: UIButton!
    @IBOutlet weak var faveLabel: UILabel!
    @IBOutlet weak var RTButton: UIButton!
    @IBOutlet weak var RTLabel: UILabel!
    
    var tweet: Tweet! {
        didSet {
            let user: User = tweet.author!
            nameLabel.text = user.name as? String
            let twitterName = user.screenname as! String
            twitterNameLabel.text = "@\(twitterName)"

            timeLabel.text = tweet.timeString
            
            tweetLabel.text = tweet.text as? String
            
            RTLabel.text = "\(tweet.RTs)"
            
            faveLabel.text = "\(tweet.faves)"
            
            let imageRequest = NSURLRequest(URL: user.profileUrl!)
            
            profPicView.setImageWithURLRequest(imageRequest, placeholderImage: UIImage(named: "defaulttwitter"), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
                self.profPicView.image = image
            }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
                print(error)
            }
            profPicView.layer.cornerRadius = profPicView.frame.height/12
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
