//
//  LoginViewController.swift
//  twitter
//
//  Created by Angeline Rao on 6/27/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onLogIn(sender: AnyObject) {
        TwitterClientSM.sharedInstance.login({
            //self.performSegueWithIdentifier("loginSegue", sender: nil)
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            
            let profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
            profileViewController.tabBarItem.title = "Profile"
            
            
            let mentionsViewController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
            mentionsViewController.tabBarItem.title = "Mentions"
            let vc = storyboard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
            
            let containerViewController = ContainerViewController()
            containerViewController.tabBarItem.title = "Home"
            containerViewController.tabBarItem.image = UIImage(named: "home-ios-icon")
            
            vc.viewControllers = [containerViewController, mentionsViewController, profileViewController]
            
            self.presentViewController(vc, animated: true, completion: { 
                print("loggin in")
            })
            
            
        }) { (error: NSError) in
            print(error.localizedDescription)
        }
    
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
