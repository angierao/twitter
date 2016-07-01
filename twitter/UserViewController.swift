//
//  UserViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/29/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]?
    var user: User?
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterNameLabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        
        TwitterClientSM.sharedInstance.profileTimeline((user!.screenname)! as String, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
            }, failure: { (error: NSError) in
                print(error)
        })
        
        nameLabel.text = user!.name as? String
        let twitterName = user!.screenname as! String
        twitterNameLabel.text = "@\(twitterName)"
        descriptionLabel.text = user?.tagline as? String
        
        followingLabel.text = "\(user!.following)"
        followersLabel.text = "\(user!.followers)"
        let imageRequest = NSURLRequest(URL: user!.profileUrl!)
        
        profPicView.setImageWithURLRequest(imageRequest, placeholderImage: UIImage(named: "defaulttwitter"), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            self.profPicView.image = image
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            print(error)
        }
        profPicView.layer.cornerRadius = profPicView.frame.height/12
        
        let backgroundRequest = NSURLRequest(URL: (user?.backgroundUrl)!)
        backgroundView.setImageWithURLRequest(backgroundRequest, placeholderImage: UIImage(), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            self.backgroundView.image = image
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            print(error)
        }

        
        


    }
    
    @IBAction func onRT(sender: AnyObject) {
        
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let tweet = tweets![(indexPath?.row)!]
        tweet.RTs = tweet.RTs + 1
        cell.RTLabel.text = "\(tweet.RTs)"
        
        TwitterClientSM.sharedInstance.retweet(tweet.id, success: { (tweet: Tweet) in
            self.tweets?.append(tweet)
            self.tableView.reloadData()
            }, failure:  { (error: NSError) in
                print(error)
        })

    }
    @IBAction func onFave(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let tweet = tweets![(indexPath?.row)!]
        
        
        if !tweet.favorited! {
            tweet.faves = tweet.faves + 1
            cell.faveLabel.text = "\(tweet.faves)"
            let favorited = UIImage(named: "favorited")
            cell.faveButton.setImage(favorited, forState: UIControlState.Normal)
            TwitterClientSM.sharedInstance.fave(tweet.id, success: { (tweet: Tweet) in
                self.tableView.reloadData()
                }, failure: { (error: NSError) in
                    print(error)
            })
        }
        
        

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let userTweetCell = tableView.dequeueReusableCellWithIdentifier("UserTweetCell") as! UserTweetCell
        userTweetCell.tweet = tweets![indexPath.row]
        return userTweetCell
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
