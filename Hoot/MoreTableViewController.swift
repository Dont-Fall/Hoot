//
//  MoreTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit
import Social

class MoreTableViewController: UITableViewController {
    
    var sectionZero = ["Daily Token","1 Token For 10 Points", "5 Tokens For 100 Points", "10 Tokens For 175 Points"]
    var sectionOne = ["Twitter", "Facebook", "Rate Hoot"]
    var sectionTwo = ["Rules", "Contact Us"]
    var sectionThree = ["My Questions", "My Class Questions", "Log Out"]
    var points = String()
    var cdTime: String!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let currentUser = PFUser.currentUser()
        currentUser?.fetchInBackgroundWithBlock(nil)
        points = String(currentUser!.objectForKey("points")!)
        let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
        self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentUser = PFUser.currentUser()
        currentUser?.fetchInBackgroundWithBlock(nil)
        points = String(currentUser!.objectForKey("points")!)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "More"
        //Daily Token
        let date = NSDate()
        let hoursPassed = NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: (currentUser!["dailyCD"])! as! NSDate, options: []).hour
        if abs(hoursPassed) >= 24{
            currentUser?["dailyTokenAvail"] = true
            currentUser?.saveInBackground()
        }else{
            cdTime = String(24+hoursPassed)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        if section == 0 {
            return 4
        }else if section == 1 {
            return 3
        }else if section == 2 {
            return 2
        }else {
            return 3
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Get Tokens"
        }else if section == 1 {
            return "Help Us Out"
        }else if section == 2 {
            return "Extra Information"
        }else {
            return "My Stuff"
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("moreCell", forIndexPath: indexPath)
        let row = indexPath.row
        // Configure the cell...
        if indexPath.section == 0 {
            cell.textLabel?.text = sectionZero[row]
        }else if indexPath.section == 1 {
            cell.textLabel?.text = sectionOne[row]
        }else if indexPath.section == 2 {
            cell.textLabel?.text = sectionTwo[row]
        }else {
            cell.textLabel?.text = sectionThree[row]
        }
    return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if indexPath.section == 0{
            let currentUser = PFUser.currentUser()
            if row == 0{
                if currentUser?.objectForKey("dailyTokenAvail")!.boolValue == true{
                    currentUser?.incrementKey("tokens", byAmount: 1)
                    currentUser?["dailyTokenAvail"] = false
                    currentUser?.saveInBackground()
                    currentUser?.fetchInBackgroundWithBlock(nil)
                    let alert = UIAlertController(title: "Token Obtained", message: "You now have 1 more question token.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Cool Down", message: "Your daily token isn't available yet, come back in \(cdTime) hours.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
                
            }else if row == 1{
                if Int((currentUser?.objectForKey("tokens"))! as! NSNumber) >= 50{
                    let alert = UIAlertController(title: "Max Tokens", message: "You already have over 50 tokens, save your points for some other cool stuff.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else if Int((currentUser?.objectForKey("points"))! as! NSNumber) >= 100{
                    currentUser?.incrementKey("tokens", byAmount: 1)
                    currentUser?.incrementKey("points", byAmount: -25)
                    currentUser?.saveInBackground()
                    currentUser?.fetchInBackgroundWithBlock(nil)
                    points = String(currentUser!.objectForKey("points")!)
                    let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
                    self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
                    let alert = UIAlertController(title: "Tokens Obtained", message: "You now have 10 more question tokens.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Not Enough Points", message: "You do not have enough points to trade in.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
            }else if row == 2{
                if Int((currentUser?.objectForKey("tokens"))! as! NSNumber) >= 50{
                    let alert = UIAlertController(title: "Max Tokens", message: "You already have over 50 tokens, save your points for some other cool stuff.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else if Int((currentUser?.objectForKey("points"))! as! NSNumber) >= 250{
                    currentUser?.incrementKey("tokens", byAmount: 5)
                    currentUser?.incrementKey("points", byAmount: -100)
                    currentUser?.saveInBackground()
                    currentUser?.fetchInBackgroundWithBlock(nil)
                    points = String(currentUser!.objectForKey("points")!)
                    let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
                    self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
                    let alert = UIAlertController(title: "Tokens Obtained", message: "You now have 20 more question tokens.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Not Enough Points", message: "You do not have enough points to trade in.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
            }else{
                if Int((currentUser?.objectForKey("tokens"))! as! NSNumber) >= 50{
                    let alert = UIAlertController(title: "Max Tokens", message: "You already have over 50 tokens, save your points for some other cool stuff.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else if Int((currentUser?.objectForKey("points"))! as! NSNumber) >= 400{
                    currentUser?.incrementKey("tokens", byAmount: 10)
                    currentUser?.incrementKey("points", byAmount: -175)
                    currentUser?.saveInBackground()
                    currentUser?.fetchInBackgroundWithBlock(nil)
                    points = String(currentUser!.objectForKey("points")!)
                    let myPoints:UIBarButtonItem = UIBarButtonItem(title: self.points, style: .Plain, target: self, action: nil)
                    self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
                    let alert = UIAlertController(title: "Tokens Obtained", message: "You now have 50 more question tokens.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }else{
                    let alert = UIAlertController(title: "Not Enough Points", message: "You do not have enough points to trade in.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
            }
        }else if indexPath.section == 1 {
            if row == 0{
                let twitterPost = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterPost.setInitialText("Everyone go to the app store and download Hoot!")
                let currentUser = PFUser.currentUser()
                if currentUser!["tweetSent"].boolValue == false{
                currentUser!.incrementKey("points", byAmount: 10)
                currentUser!["tweetSent"] = true
                currentUser?.saveInBackground()
                }
                self.presentViewController(twitterPost, animated: true, completion: nil)
            }else if row == 1{
                let facebookPost = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookPost.setInitialText("Everyone go to the app store and download Hoot!")
                let currentUser = PFUser.currentUser()
                if currentUser!["faceBookSent"].boolValue == false{
                currentUser!.incrementKey("points", byAmount: 10)
                currentUser!["faceBookSent"] = true
                currentUser?.saveInBackground()
                }
                self.presentViewController(facebookPost, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Coming Soon", message: "You'll be able to give us an awesome review as soon as we link to the App Store.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                presentViewController(alert, animated: true, completion: nil)
            }
        }else if indexPath.section == 2 {
            if row == 0{
                self.performSegueWithIdentifier("rulesSegue", sender: self)
            }else{
                self.performSegueWithIdentifier("contactUsSegue", sender: self)
            }
        }else {
            if row == 0{
                //My Questions
                self.performSegueWithIdentifier("myQuestionsSegue", sender: self)
            }else if row == 1{
                //My Class Questions
                self.performSegueWithIdentifier("myClassQuestionsSegue", sender: self)
            }else {
                //Log Out
                PFUser.logOut()
                self.performSegueWithIdentifier("logOutSegue", sender: self)
            }
        }
        
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        header.alpha = 1.0 //make the header transparent
    }
    
}
