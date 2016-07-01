//
//  ContainerViewController.swift
//  twitter
//
//  Created by Angeline Rao on 7/1/16.
//  Copyright © 2016 Angeline Rao. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
    case LeftCollapsed
    case LeftPanelExpanded
}

class ContainerViewController: UIViewController, CenterViewControllerDelegate {
    
    var centerNavigationController: UINavigationController!
    var centerViewController: TweetsViewController!
    var currentState: SlideOutState = .LeftCollapsed
    var leftViewController: TrendingViewController?
    let centerPanelExpandedOffset: CGFloat = 60
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMoveToParentViewController(self)
    }
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(notAlreadyExpanded)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            currentState = .LeftPanelExpanded
            
            //animateCenterPanelXPosition(CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
            let float: CGFloat = CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset
            animateCenterPanelXPosition(float, completion: { (success: Bool) in
                print("animated")
            })
        } else {
            animateCenterPanelXPosition(0) { finished in
                self.currentState = .LeftCollapsed
                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            
            addChildSidePanelController(leftViewController!)
        }
    }
    
    func addChildSidePanelController(sidePanelController: TrendingViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
    }
    
    func collapseSidePanels() {
        switch (currentState) {
        case .LeftPanelExpanded:
            toggleLeftPanel()
        default:
            break
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

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> TrendingViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TrendingViewController") as? TrendingViewController
    }
    
//    class func rightViewController() -> SidePanelViewController? {
//        return mainStoryboard().instantiateViewControllerWithIdentifier("RightViewController") as? SidePanelViewController
//    }
    
    class func centerViewController() -> TweetsViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TweetsViewController") as? TweetsViewController
    }
    
}
