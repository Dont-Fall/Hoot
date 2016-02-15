//
//  SubjectTableViewController.swift
//  Hoot
//
//  Created by Jake Ulasevich on 1/3/16.
//  Copyright © 2016 Nitrox Development. All rights reserved.
//

import UIKit

class SubjectTableViewController: UITableViewController {
    
    //MARK: Extras
    var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 150, 150))
    
    //MARK: Subject List
    var subjectList = ["Math", "English", "Science", "Business", "Computer Science", "Finance", "Art", "Economics", "History", "Other"]

    //VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        //MARK: Nav Bar Customize
        navigationController!.navigationBar.barTintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let subjectBackBtn:UIBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "subjectBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.systemFontOfSize(14.0)], forState: UIControlState.Normal)
        self.navigationItem.setLeftBarButtonItem(subjectBackBtn, animated: true)
        self.title = "Subjects"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //MARK: Set Row Height
        tableView.rowHeight = 50
    }
    
    //DID RECIEVE MEMORY WARNING
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Go Back Function
    func subjectBack() {
        self.actInd.startAnimating()
        self.performSegueWithIdentifier("subjectBackSegue", sender: self)
        self.actInd.stopAnimating()
    }

    //Number of Sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //Assign Table Count
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return subjectList.count
    }
    
    //Assign Checkmark to Subject
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentUser = PFUser.currentUser()
        let cell = tableView.dequeueReusableCellWithIdentifier("subjectIdentifier", forIndexPath: indexPath) as UITableViewCell
        let currentSubject = currentUser!["subject"]
        let subject = subjectList[indexPath.row]
        cell.textLabel?.text = subject
        if currentSubject as! String == String(subjectList[indexPath.row]){
            cell.tintColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
            cell.accessoryType = .Checkmark
        }
        return cell
    }
    
    //Section Title
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Tap to Choose"
    }
    
    //Set Current Subject
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let currentUser = PFUser.currentUser()
        currentUser!["subject"] = subjectList[row]
        currentUser!.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if error == nil {
                // Success, no creating error.
                self.actInd.startAnimating()
                self.performSegueWithIdentifier("subjectSelectedSegue", sender: self)
                self.actInd.startAnimating()
                //Add to que
            } else {
                print("Error")
            }
        }
    }
    
    //Edit Section Header
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView //recast your view as a UITableViewHeaderFooterView
        header.textLabel!.textColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        header.alpha = 1.0 //make the header transparent
    }

}
