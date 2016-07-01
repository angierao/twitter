//
//  TrendingViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/30/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import CoreLocation

class TrendingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var trends: [Trend]?
    var locManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func trendButtonTapped(sender: AnyObject) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TrendingCell
        let indexPath = tableView.indexPathForCell(cell)
        let trend = trends![(indexPath?.row)!]
        let url = NSURL(string: trend.url!)
        UIApplication.sharedApplication().openURL(url!)
    }
    @IBAction func trendTapped(sender: UITapGestureRecognizer) {
        print("tapped")
        let view = sender.view
        let cell = view?.superview as! TrendingCell
        let indexPath = tableView.indexPathForCell(cell)
        let trend = trends![(indexPath?.row)!]
        let url = NSURL(string: trend.url!)
        UIApplication.sharedApplication().openURL(url!)
    }
    override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0)
        titleLabel.text = "Trending near you"
        titleLabel.textColor = UIColor.whiteColor()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.startMonitoringSignificantLocationChanges()
        
        // Check if the user allowed authorization
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Authorized)
        {
            print(locManager.location?.coordinate.latitude)
            let parameters : NSDictionary = [
                "lat": (locManager.location?.coordinate.latitude)!,
                "long": (locManager.location?.coordinate.longitude)!
            ]
            TwitterClientSM.sharedInstance.closestTrends(parameters, success: { (woeid: Int) in
                let parameters : NSDictionary = [
                    "id": woeid
                ]
                    TwitterClientSM.sharedInstance.trends(parameters, success: { (trends: [Trend]) in
                        self.trends = trends
                        self.tableView.reloadData()
                    }) { (error: NSError) in
                        print(error)
                    }
                }, failure: { (error: NSError) in
                    print(error)
            })

            
        } else {
            print("not authorized")
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trends?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let trendingCell = tableView.dequeueReusableCellWithIdentifier("TrendingCell") as! TrendingCell
        
        trendingCell.trend = self.trends![indexPath.row]
        trendingCell.backgroundColor = UIColor(red: 85/255, green: 172/255, blue: 238/255, alpha: 1.0)
        trendingCell.nameLabel.textColor = UIColor.whiteColor()
        trendingCell.tweetVolumeLabel.textColor = UIColor.whiteColor()
        trendingCell.mentionsLabel.textColor = UIColor.whiteColor()
        
        return trendingCell
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
