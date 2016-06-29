//
//  TweetsViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/27/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tweets: [Tweet]?
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        composeButton()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TwitterClientSM.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
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
        print("compose")
        performSegueWithIdentifier("composeSegue", sender: nil)
        //presentViewController(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
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
    }
    

}
