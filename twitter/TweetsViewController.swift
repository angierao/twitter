//
//  TweetsViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/27/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var tweets: [Tweet]?
    var tweetsLoaded = 20
    var loadingMoreView: InfiniteScrollActivityView?
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        composeButton()
        
        // Set up Infinite Scroll loading indicator
        
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let parameters: NSDictionary = [
            "count": tweetsLoaded
        ]
        TwitterClientSM.sharedInstance.homeTimeline(parameters, success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
            }, failure: { (error: NSError) in
                print(error)
        })
        
    }
    
    func composeButton() {
        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.setImage(UIImage(named: "compose.png"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(TweetsViewController.compose), forControlEvents: UIControlEvents.TouchUpInside)
        button.frame = CGRectMake(0, 0, 20, 20)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    func compose() {
        performSegueWithIdentifier("composeSegue", sender: nil)
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClientSM.sharedInstance.logout()
        
    }
    
    @IBAction func profileButtonTapped(sender: AnyObject) {
        

        
    }
    
    @IBAction func onFave(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetCell
        let indexPath = tableView.indexPathForCell(cell)
        
        let tweet = tweets![(indexPath?.row)!]
        tweet.faves = tweet.faves + 1
        cell.faveLabel.text = "\(tweet.faves)"
        
        TwitterClientSM.sharedInstance.fave(tweet.id, success: { (tweet: Tweet) in
            self.tableView.reloadData()
        }, failure: { (error: NSError) in
                print(error)
        })
        
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCellWithIdentifier("TweetCell") as! TweetCell
        
        tweetCell.tweet = self.tweets![indexPath.row]
        
        return tweetCell
    }
    
    func loadMoreData() {
        tweetsLoaded += 20
        let parameters: NSDictionary = [
            "count": tweetsLoaded
        ]
        print(tweetsLoaded)
        TwitterClientSM.sharedInstance.homeTimeline(parameters, success: { (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.isMoreDataLoading = false
            self.tableView.reloadData()
            }, failure: { (error: NSError) in
                print(error)
        })
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //print(isMoreDataLoading)
        if (!isMoreDataLoading) {
            
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                loadMoreData()
            }
            
        }
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
        
        if segue.identifier == "detailSegue" {
            let detailVC = segue.destinationViewController as! DetailViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let tweet = tweets![indexPath!.row]
            detailVC.tweet = tweet

        }
        else if segue.identifier == "userProfileSegue" {
            let userVC = segue.destinationViewController as! UserViewController
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let tweet = tweets![(indexPath?.row)!]
            userVC.user = tweet.author
        }
        else if segue.identifier == "replySegue" {
            let composeVC = segue.destinationViewController as! ComposeViewController
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! TweetCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let tweet = tweets![(indexPath?.row)!]
            composeVC.replyUser = tweet.author?.screenname as? String
            
        }
    }
    

}
