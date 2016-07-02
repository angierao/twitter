//
//  Message.swift
//  twitter
//
//  Created by Angeline Rao on 7/1/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class Message: NSObject {
    var text: NSString?
    var timestamp: NSDate?
    var timeString: String?
    var author: User?
    var recipient: User?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as! String
        let authorDictionary = dictionary["sender"] as! NSDictionary
        author = User(dictionary: authorDictionary)
        
        let recipientDictionary = dictionary["recipient"] as! NSDictionary
        recipient = User(dictionary: recipientDictionary)
        
        let timestampString = dictionary["created_at"] as? String
        
        if let timestampString = timestampString {
            let formatter = NSDateFormatter()
            //formatter.dateFormat = "ss.mm.HH.yy.MM.dd"
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }

        
        let creationDate = NSCalendar.currentCalendar().components([.Year, .Month, .Day, .Hour , .Minute, .Second], fromDate: timestamp!)
        
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

        
        
    }
    
    class func messagesWithArray(dictionaries: [NSDictionary]) -> [Message]{
        var messages = [Message]()
        print("hello")
        
        for dictionary in dictionaries {
            let message = Message(dictionary: dictionary)
            print(message)
            messages.append(message)
        }
        
        return messages
        
    }

}
