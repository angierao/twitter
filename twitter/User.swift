//
//  User.swift
//  twitter
//
//  Created by Angeline Rao on 6/27/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class User: NSObject {
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        //name = dictionary["name"] as? String
        //screenname = dictionary["name"] as? String
        
        //let profileUrlString = dictionary["profile_image_url_https"] as? String
        
        /*if let profileUrlString = profileUrlString {
            profileUrl = NSURL(string: profileUrlString)
        }*/
        
        //tagline = dictionary["description"] as? String
    }

    var name: NSString? {
        get {
            return dictionary["name"] as? String
        }
    }
    
    var screenname: NSString? {
        get {
            return dictionary["screen_name"] as? String
        }
    }
    
    var profileUrl: NSURL? {
        get {
            let profileUrlString = dictionary["profile_image_url_https"] as? String
            return NSURL(string: profileUrlString!)

        }
    }
    var tagline: NSString? {
        get {
            return dictionary["description"] as? String
        }
    }
    
    var dictionary: NSDictionary
    
    static let userDidLogoutNotif = "UserDidLogout"
    
    
    static var _currentUser: User?
    
    class var currentUser: User? {
        get {
            
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        set(user) {
            
            _currentUser = user
            
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary, options: [])
                
                defaults.setObject(data, forKey: "currentUserData")
            }
            else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
    
    
}
