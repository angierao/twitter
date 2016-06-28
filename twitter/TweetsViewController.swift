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
        
        
        TwitterClientSM.sharedInstance.homeTimeline({ (tweets: [Tweet]) in
            
            self.tweets = tweets
            self.tableView.reloadData()
        }) { (error: NSError) in
                print(error)
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogOut(sender: AnyObject) {
        TwitterClientSM.sharedInstance.logout()
        
    }
    
    @IBAction func onFave(sender: AnyObject) {
        
    }
    
    @IBAction func onRT(sender: AnyObject) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
