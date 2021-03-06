//
//  ProfileViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/28/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterNameLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    var tweets: [Tweet]?
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClientSM.sharedInstance.logout()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        navigationController!.navigationBar.barTintColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0)
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.title = "Profile"
        
        

        let user = User.currentUser
        
        nameLabel.text = user!.name as? String
        let twitterName = user!.screenname as! String
        twitterNameLabel.text = "@\(twitterName)"
        descriptionLabel.text = user!.tagline as? String
        let imageRequest = NSURLRequest(URL: user!.profileUrl!)
        
        followersLabel.text = "\(user!.followers)"
        followingLabel.text = "\(user!.following)"
        
        profPicView.setImageWithURLRequest(imageRequest, placeholderImage: UIImage(named: "defaulttwitter"), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            self.profPicView.image = image
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            print(error)
        }
        
        profPicView.layer.cornerRadius = profPicView.frame.height/12
        
        TwitterClientSM.sharedInstance.currentAccount({ (user: User) in
            print(user.backgroundUrl)
        }) { (error: NSError) in
                print(error)
        }
        
        let backgroundRequest = NSURLRequest(URL: (user?.backgroundUrl)!)
        print("printing \(user?.backgroundUrl)")
        backgroundView.setImageWithURLRequest(backgroundRequest, placeholderImage: UIImage(), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            self.backgroundView.image = image
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            print(error)
        }

        // Do any additional setup after loading the view.
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
    override func viewWillAppear(animated: Bool) {
        let user = User.currentUser
        
        TwitterClientSM.sharedInstance.profileTimeline((user!.screenname)! as String, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
            }, failure: { (error: NSError) in
                print(error)
        })
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileCell
        profileCell.tweet = tweets![indexPath.row]
        profileCell.selectionStyle = UITableViewCellSelectionStyle.None
        return profileCell
        
        
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
        
        if segue.identifier == "profileReplySegue" {
            let composeVC = segue.destinationViewController as! ComposeViewController
            let button = sender as! UIButton
            let view = button.superview!
            let cell = view.superview as! ProfileCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let tweet = tweets![(indexPath?.row)!]
            composeVC.replyUser = tweet.author?.screenname as? String
        }
        else if segue.identifier == "profileDetailSegue" {
            let detailVC = segue.destinationViewController as! DetailViewController
            
            let indexPath = tableView.indexPathForCell(sender as! UITableViewCell)
            let tweet = tweets![indexPath!.row]
            detailVC.tweet = tweet
            
        }
    }
    

}
