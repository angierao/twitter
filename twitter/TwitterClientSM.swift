//
//  TwitterClientSM.swift
//  twitter
//
//  Created by Angeline Rao on 6/27/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager
import CoreLocation

class TwitterClientSM: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClientSM(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "HTzblicMbQwaxauXoDKyVoLMC", consumerSecret: "YTXQ8ARoOKhSMJKQDQnBZt5EUHfTsr5gYc2RhFTehsa8Q4TQMj")
    
    var loginSuccess: (() -> ())?
    var loginFailure: (NSError -> ())?
    
    func login(success: () -> (), failure: NSError -> ()) {
        loginSuccess = success
        loginFailure = failure
        deauthorize()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterclient://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token )")
            UIApplication.sharedApplication().openURL(url!)
        }) { (error: NSError!) in
            print("error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }

    }
    
    func logout(){
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotif, object: nil)
        
    }
    
    func closestTrends(parameters: NSDictionary, success: Int -> (), failure: NSError -> ()) {
        GET("1.1/trends/closest.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let loc = dictionaries[0]
            //print("\(loc["woeid"] as! Int)")
            success(loc["woeid"] as! Int)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
    }
    
    func trends(woeid: NSDictionary, success: [Trend] -> (), failure: NSError -> ()) {
        GET("1.1/trends/place.json", parameters: woeid, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let array = response as! NSArray
            let dictionaries = array[0].valueForKeyPath("trends") as! [NSDictionary]
            //print(dictionaries)
            let trends = Trend.trendsWithArray(dictionaries)
            success(trends)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        }
    }
    
    
    func retweet(id: Int, success: (Tweet) -> (), failure: NSError -> ()) {
        print("1.1/statuses/retweet/\(id).json")
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            //print(response)
            let dictionary = response as! NSDictionary
            
            let tweet = Tweet(dictionary: dictionary)
            
            success(tweet)
            
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    
    /*func unretweet(tweet: Tweet) {
            if tweet.retweeted
    }*/
    
    func newTweet(text: NSDictionary, success: (Tweet) -> (), failure: NSError -> ()) {
        POST("1.1/statuses/update.json", parameters: text, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func fave(id: Int, success: (Tweet) -> (), failure: NSError -> ()) {
        
        POST("1.1/favorites/create.json?id=\(id)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            
            let dictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
            
            }, failure:  { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
        
    }
    func handleOpenUrl(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            
            self.currentAccount({ (user: User) in
                User.currentUser = user
                self.loginSuccess?()
                }, failure: { (error: NSError) in
                self.loginFailure!(error)
            })
        }) { (error: NSError!) in
            print(error.localizedDescription)
            self.loginFailure?(error)
        }
    }
    func homeTimeline(parameters: NSDictionary, success: ([Tweet]) -> (), failure: NSError -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: parameters, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })

    }
    
    func profileTimeline(screenname: String, success: ([Tweet]) -> (), failure: NSError -> ())
    {
        GET("1.1/statuses/user_timeline.json?screen_name=\(screenname)&count=20", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            
            let tweets = Tweet.tweetsWithArray(dictionaries)
            
            success(tweets)

            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
    
    func currentAccount(success: User -> (), failure: NSError -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in

            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
                failure(error)
        })
    }
}
