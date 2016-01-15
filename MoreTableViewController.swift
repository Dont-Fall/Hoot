//
//  MoreTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/13/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class MoreTableViewController: UITableViewController {
    
    var sectionOne = ["Twitter", "Facebook", "App Store"]
    var sectionTwo = ["Rules", "Contact Us"]
    var sectionThree = ["My Questions", "My Class Questions", "Log Out"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var points = String(PFUser.currentUser()!.objectForKey("points")!)
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 102.0 / 255.0, green: 204.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
        let myPoints:UIBarButtonItem = UIBarButtonItem(title: points, style: .Plain, target: self, action: nil)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setRightBarButtonItem(myPoints, animated: true)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.title = "More"
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
            return 3
        }else if section == 1 {
            return 2
        }else {
            return 3
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Help Us Out"
        }else if section == 1 {
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
            cell.textLabel?.text = sectionOne[row]
        }else if indexPath.section == 1 {
            cell.textLabel?.text = sectionTwo[row]
        }else {
            cell.textLabel?.text = sectionThree[row]
        }
    return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if indexPath.section == 0 {
            if row == 0{
                //Twitter
            }else if row == 1{
                //Facebook
            }else{
                //App Store
            }
        }else if indexPath.section == 1 {
            if row == 0{
                //Rules
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
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
