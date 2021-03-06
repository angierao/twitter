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
        
        navigationController!.navigationBar.barTintColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.title = "\(user!.name!)"
        
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
        
        let grayRT = UIImagePNGRepresentation(UIImage(named: "retweet-action")!)
        let buttonImage = UIImagePNGRepresentation(button.currentImage!)
        
        if grayRT!.isEqualToData(buttonImage!) {
            print("inside")
            tweet.retweeted = true
            let greenRT = UIImage(named: "retweeted-green")
            cell.RTButton.setImage(greenRT, forState: UIControlState.Normal)
            tweet.RTs = tweet.RTs + 1
            cell.RTLabel.text = "\(tweet.RTs)"
            
            TwitterClientSM.sharedInstance.retweet(tweet.id, success: { (tweet: Tweet) in
                self.tweets?.append(tweet)
                self.tableView.reloadData()
                }, failure:  { (error: NSError) in
                    print(error)
            })
            tableView.reloadData()
            
            
        }
        else {
            tweet.retweeted = false
            let grayRT = UIImage(named: "retweet-action")
            cell.RTButton.setImage(grayRT, forState: UIControlState.Normal)
            tweet.RTs = tweet.RTs - 1
            cell.RTLabel.text = "\(tweet.RTs)"
        }


    }
    @IBAction func onFave(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! UserTweetCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let tweet = tweets![(indexPath?.row)!]
        
        let grayHeart = UIImagePNGRepresentation(UIImage(named: "favorite-action")!)
        let buttonImage = UIImagePNGRepresentation(button.currentImage!)
        
        if grayHeart!.isEqualToData(buttonImage!) {
            print("1")
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
        else {
            print("2")
            tweet.faves = tweet.faves - 1
            cell.faveLabel.text = "\(tweet.faves)"
            let favorite = UIImage(named: "favorite-action")
            cell.faveButton.setImage(favorite, forState: UIControlState.Normal)
            TwitterClientSM.sharedInstance.unfave(tweet.id, success: { (tweet: Tweet) in
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
        userTweetCell.selectionStyle = UITableViewCellSelectionStyle.None
        return userTweetCell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "userReplySegue" {
            let composeVC = segue.destinationViewController as! ComposeViewController
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! UserTweetCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let tweet = tweets![(indexPath?.row)!]
            composeVC.replyUser = tweet.author?.screenname as? String
        }
        else if segue.identifier == "userDetailSegue" {
            let detailVC = segue.destinationViewController as! DetailViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let tweet = tweets![indexPath!.row]
            detailVC.tweet = tweet
            
        }

    }
    

}
