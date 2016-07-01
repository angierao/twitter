//
//  Trend.swift
//  twitter
//
//  Created by Angeline Rao on 6/30/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class Trend: NSObject {
    var name: String?
    var tweetVolume: Int!
    var url: String?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        if let tweetVolume = dictionary["tweet_volume"] as? Int {
            self.tweetVolume = tweetVolume
        }
        else {
            self.tweetVolume = 0
        }
        url = dictionary["url"] as? String
    }
    
    class func trendsWithArray(dictionaries: [NSDictionary]) -> [Trend]{
        var trends = [Trend]()
        
        for dictionary in dictionaries {
            let trend = Trend(dictionary: dictionary)
            
            trends.append(trend)
        }
        
        return trends
        
    }
}
