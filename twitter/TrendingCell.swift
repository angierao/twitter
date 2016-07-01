//
//  TrendingCell.swift
//  twitter
//
//  Created by Angeline Rao on 6/30/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class TrendingCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tweetVolumeLabel: UILabel!
    @IBOutlet weak var mentionsLabel: UILabel!
    
    var trend: Trend! {
        didSet {
            nameLabel.text = trend?.name
            tweetVolumeLabel.text = "\(trend?.tweetVolume)"
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
