//
//  Tweet.swift
//  twitter
//
//  Created by Angeline Rao on 6/27/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var timeString: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var author: User?
    var id: Int = 0
    var RTs: Int = 0
    var faves: Int = 0
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            //formatter.dateFormat = "ss.mm.HH.yy.MM.dd"
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        
        //let creationDate = NSDateComponents()
        
        let creationDate = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour , .Minute, .Second], fromDate: timestamp!)
        
        //var createdAtString = NSDate()
//        if let timestampString = timestampString {
//            let formatter = NSDateFormatter()
//            formatter.dateFormat = "ss.mm.HH.yy.MM.dd"
//            timestamp = formatter.dateFromString(timestampString)!
//        }
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Hour , .Minute, .Second], fromDate:date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let min = components.minute
        let sec = components.second
        
        let currentDate = NSDateComponents()
        currentDate.year = year
        currentDate.month = month
        currentDate.day = day
        currentDate.hour = hour
        currentDate.minute = min
        currentDate.second = sec
        
        //let today = NSCalendar.currentCalendar().dateFromComponents(currentDate)!
        
        //let dateFormatter = NSDateFormatter()
        //let date = NSDate()
        //dateFormatter.dateFormat = "ss.mm.HH.yy.MM.dd"
        //let dateString = dateFormatter.stringFromDate(today)
        
        let creationDay = NSCalendar.currentCalendar().dateFromComponents(creationDate)!
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d"

        if currentDate.year == creationDate.year {
            if currentDate.month == creationDate.month {
                if currentDate.day == creationDate.day {
                    if currentDate.hour == creationDate.hour {
                        if currentDate.minute == creationDate.minute {
                            timeString = "Just now"
                        }
                        else {
                            // minutes first differ
                            let minDiff = currentDate.minute - creationDate.minute
                            timeString = "\(minDiff)m"
                        }
                    }
                    else {
                        // hour first differs
                        let currentDateMin = (currentDate.hour) * 60 + currentDate.minute
                        let creationDateMin = (creationDate.hour) * 60 + creationDate.minute
                        let minDiff = currentDateMin - creationDateMin
                        if minDiff < 60 {
                            timeString = "\(minDiff)m"
                        }
                        else {
                            let hourDiff = currentDate.hour - creationDate.hour
                            timeString = "\(hourDiff)h"
                        }
                    }
                }
                else {
                    let currentDateHour = (currentDate.day) * 24 + currentDate.hour
                    let creationDateHour = (creationDate.day) * 24 + creationDate.hour
                    let hourDiff = currentDateHour - creationDateHour
                    if hourDiff < 24 {
                        timeString = "\(hourDiff)h"
                    }
                    else {
                        timeString = dateFormatter.stringFromDate(creationDay)
                    }
                }
            }
            else {
                timeString = dateFormatter.stringFromDate(creationDay)
            }
        }
        else {
            timeString = dateFormatter.stringFromDate(creationDay)
        }
        
        
        let userDictionary = dictionary["user"] as! NSDictionary
        author = User(dictionary: userDictionary)
        
        id = dictionary["id"] as! Int
        
        RTs = dictionary["retweet_count"] as? Int ?? 0
        
        faves = dictionary["favorite_count"] as? Int ?? 0
        
    }
    
    class func newTweet(text: String) {
        //let tweet = Tweet()
    }
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
        
    }

    
}
