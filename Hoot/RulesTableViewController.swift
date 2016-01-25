//
//  RulesTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/18/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class RulesTableViewController: UITableViewController {
    
    let ruleOne = "1) No cheating.  The purpose of Hoot is to help others understand their issues, not ot copy word for word.  Under no circumstance should you be using this application during a test, punishment is up to the discretion of the school."
    let ruleTwo = "2) No spamming.  Please refrain from posting the same question repeatedly.  If it is not answered within 24 hours you may feel free to repost it.  Those who continue to post the same question over and over are subject to an account suspension."
    let ruleThree = "3) No harassing.  Everyone is here because they are struggling with some academic issue and this platform is ment for helping, not putting others down.  Please keep this community a positive area."
    let ruleFour = "4) No personal information.  Please refrain from posting both yours, and others, personal information.  No phone numbers, home adresses, social media, or other information of that nature."
    let ruleFive = "5) Placeholder"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: Nav Bar Customize
        let rulesBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "rulesBack")
        self.navigationItem.setLeftBarButtonItem(rulesBackBtn, animated: true)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.title = "Rules"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rulesBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rulesCell", forIndexPath: indexPath) as! RulesTableViewCell
        let row = indexPath.row
        if row == 0 {
            cell.rulesTV.text = ruleOne
        }else if row == 1{
            cell.rulesTV.text = ruleTwo
        }else if row == 2{
            cell.rulesTV.text = ruleThree
        }else if row == 3{
            cell.rulesTV.text = ruleFour
        }else if row == 4{
            cell.rulesTV.text = ruleFive
        }
        // Configure the cell...
        

        return cell
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
