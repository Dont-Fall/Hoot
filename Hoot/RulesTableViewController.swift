//
//  RulesTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/18/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class RulesTableViewController: UITableViewController {
    
    let ruleOne = "No cheating.  The purpose of Hoot is to help others understand their issues, not to copy word for word.  Under no circumstance should you be using this application during a test, punishment is up to the discretion of the school."
    let ruleTwo = "No spamming.  Please refrain from posting the same question repeatedly.  If it is not answered within 24 hours you may feel free to repost it.  In the mean time feel free to help others out."
    let ruleThree = "No harassing.  Everyone is here because they are struggling with some academic issue of varying magnitude and this platform is meant for helping, not putting others down.  Please keep this community a positive area."
    let ruleFour = "No personal information.  Please refrain from posting both yours, and others, personal information.  No phone numbers, home addresses, social media, or other information of that nature."
    //let ruleFive = "Placeholder"

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
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
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("rulesCell", forIndexPath: indexPath) as! RulesTableViewCell
        let row = indexPath.row
        if row == 0 {
            cell.rulesTV.text = ruleOne
            cell.numLabel.text = "1)"
        }else if row == 1{
            cell.rulesTV.text = ruleTwo
            cell.numLabel.text = "2)"
        }else if row == 2{
            cell.rulesTV.text = ruleThree
            cell.numLabel.text = "3)"
        }else if row == 3{
            cell.rulesTV.text = ruleFour
            cell.numLabel.text = "4)"
        }/*else if row == 4{
            cell.rulesTV.text = ruleFive
            cell.numLabel.text = "5)"
        }*/
        // Configure the cell...
        

        return cell
    }

}
