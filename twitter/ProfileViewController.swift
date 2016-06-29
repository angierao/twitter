//
//  ProfileViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/28/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profPicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var twitterNameLabel: UILabel!
    
    var tweets: [Tweet]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        let user = User.currentUser
        
        TwitterClientSM.sharedInstance.profileTimeline((user!.screenname)! as String, success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()
            
            }, failure: { (error: NSError) in
                print(error)
        })
        
        nameLabel.text = user!.name as? String
        let twitterName = user!.screenname as! String
        twitterNameLabel.text = "@\(twitterName)"
        let imageRequest = NSURLRequest(URL: user!.profileUrl!)
        
        profPicView.setImageWithURLRequest(imageRequest, placeholderImage: UIImage(named: "defaulttwitter"), success: { (request: NSURLRequest, response: NSHTTPURLResponse?, image: UIImage) in
            self.profPicView.image = image
        }) { (request: NSURLRequest, response: NSHTTPURLResponse?, error: NSError) in
            print(error)
        }
        

        // Do any additional setup after loading the view.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCellWithIdentifier("ProfileCell") as! ProfileCell
        profileCell.tweet = tweets![indexPath.row]
        
        return profileCell
        
        
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
