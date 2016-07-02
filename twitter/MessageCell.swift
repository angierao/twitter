//
//  MessageCell.swift
//  twitter
//
//  Created by Angeline Rao on 7/1/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var profPicView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var message: Message! {
        didSet {
            let author: User = message.author!
            let recipient: User = message.recipient!
            nameLabel.text = recipient.name as? String
            twitterNameLabel.text = recipient.screenname as? String
            messageLabel.text = message.text as? String
            timeLabel.text = message.timeString! as String
            
            let imageRequest = NSURLRequest(URL: recipient.profileUrl!)
            
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
