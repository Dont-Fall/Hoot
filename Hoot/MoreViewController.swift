//
//  MoreViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/1/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: Nav Bar Customize
        //navigationController!.navigationBar.barTintColor = UIColor(red: 102.0 / 255.0, green: 204.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        /* BUTTONS
        let questionSubjectBtn:UIBarButtonItem = UIBarButtonItem(title: "Subject", style: .Plain, target: self, action: "questionSubject")
        let questionAskBtn:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "questionCompose")
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(questionAskBtn, animated: true)
        self.navigationItem.setLeftBarButtonItem(questionSubjectBtn, animated: true)
        */
        //self.title = "More"
        //UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Log Out
    @IBAction func moreLogOutBtn(sender: AnyObject) {
        PFUser.logOut()
        //self.actInd.startAnimating()
        //self.performSegueWithIdentifier("logOut", sender: self)
        //self.actInd.stopAnimating()
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
