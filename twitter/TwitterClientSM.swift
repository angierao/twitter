//
//  TwitterClientSM.swift
//  twitter
//
//  Created by Angeline Rao on 6/27/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClientSM: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClientSM(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "HTzblicMbQwaxauXoDKyVoLMC", consumerSecret: "YTXQ8ARoOKhSMJKQDQnBZt5EUHfTsr5gYc2RhFTehsa8Q4TQMj")
    
    var loginSuccess: (() -> ())?
    var loginFailure: (NSError -> ())?
    
    func login(success: () -> (), failure: NSError -> ()) {
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            print("got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token )")
            UIApplication.sharedApplication().openURL(url!)
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }

    }
    
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            print("got access token")
            
            self.loginSuccess?()
            
        }) { (error: NSError!) in
            print(error.localizedDescription)
            self.loginFailure!(error)
        }

    }
    func homeTimeline(success: ([Tweet]) -> (), failure: NSError -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

    }
    
    func currentAccount() {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            print("account: \(response)")
            let userDictionary = response as! NSDictionary
            //print("name: \(user!["name"])")
            
            let user = User(dictionary: userDictionary)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                print(error.localizedDescription)
        })
    }
}